//
//  DefaultEventService.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent
import FluentPostgresDriver
import Vapor

struct DefaultEventService: EventService {

    // MARK: - Instance Properties

    let parameterService: ParameterService

    // MARK: - Instance Methods

    private func isEventExists(on request: Request, with name: String) -> EventLoopFuture<Bool> {
        Event.query(on: request.db).filter(\.$name == name).first().map { event in
            event != nil
        }
    }

    // MARK: - EventService

    func create(on request: Request, form: Event.CreateForm) -> EventLoopFuture<Event.Form> {
        self.isEventExists(on: request, with: form.name).flatMapThrowing { isExists in
            guard !isExists else {
                throw Abort(.badRequest, reason: "Event with name '\(form.name)' already exists")
            }

            return Event(name: form.name, description: form.description)
        }.flatMap { (event: Event) in
            event.save(on: request.db).transform(to: event)
        }.flatMapThrowing { event in
            let eventID = try event.requireID()

            let trackerEvents = form.trackerIDs.map {
                TrackerEvent(trackerID: $0, eventID: eventID)
            }

            return (trackerEvents, eventID)
        }.flatMap { (trackerEvents: [TrackerEvent], eventID: Event.IDValue) in
            let tracketEventFuture = trackerEvents.create(on: request.db)

            let parameterFuture = form.parameters.map {
                self.parameterService.create(on: request, form: $0, eventID: eventID)
            }.flatten(on: request.eventLoop)

            return tracketEventFuture.and(parameterFuture).transform(to: eventID)
        }.flatMap { (eventID: Event.IDValue) in
            Event.query(on: request.db)
                .filter(\.$id == eventID)
                .with(\.$trackers)
                .with(\.$parameters)
                .first()
                .unwrap(or: Abort(.internalServerError))
                .map { $0.toForm() }
        }
    }

    func fetch(on request: Request) -> EventLoopFuture<[Event.Form]> {
        Event.query(on: request.db).with(\.$parameters).with(\.$trackers).all().mapEach { $0.toForm() }
    }
}
