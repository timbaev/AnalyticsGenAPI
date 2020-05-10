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

    private func update(trackers: [UUID], on request: Request, for event: Event) throws -> EventLoopFuture<Void> {
        let oldTrackerIDs = try event.trackers.map { try $0.requireID() }
        let diff = oldTrackerIDs.diffIterative(trackers, with: ==)
        let trackerIDsToDetach = diff.removed
        let trackerIDsToAttach = diff.inserted

        let trackersToDetach = try event.trackers.filter { try trackerIDsToDetach.contains($0.requireID()) }

        let trackersToAttach = trackerIDsToAttach.map {
            Tracker.find($0, on: request.db).unwrap(or: Abort(.badRequest, reason: "Tracker with id '\($0)' not found"))
        }.flatten(on: request.eventLoop)

        return trackersToAttach.and(value: trackersToDetach)
            .flatMap { (trackersToAttach: [Tracker], trackersToDetach: [Tracker]) in
                let attachFuture = event.$trackers.attach(trackersToAttach, on: request.db)
                let detachFuture = event.$trackers.detach(trackersToDetach, on: request.db)

                return detachFuture.and(attachFuture).transform(to: Void())
            }
    }

    private func update(
        parameters: [Parameter.UpdateForm],
        on request: Request,
        for event: Event
    ) -> EventLoopFuture<Void> {
        parameters.compactMap { form -> EventLoopFuture<Parameter.Form>? in
            guard let parameter = event.parameters.first(where: { $0.id == form.id }) else {
                return nil
            }

            return self.parameterService.update(on: request, parameter: parameter, form: form)
        }.flatten(on: request.eventLoop).transform(to: Void())
    }

    private func findWithRelationships(on request: Request, eventID: Event.IDValue) -> EventLoopFuture<Event> {
        Event.query(on: request.db)
            .filter(\.$id == eventID)
            .with(\.$trackers)
            .with(\.$parameters)
            .first()
            .unwrap(or: Abort.notFound(model: Event.self, for: eventID))
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
            self.findWithRelationships(on: request, eventID: eventID).map { $0.toForm() }
        }
    }

    func fetch(on request: Request) -> EventLoopFuture<[Event.Form]> {
        Event.query(on: request.db).with(\.$parameters).with(\.$trackers).all().mapEach { $0.toForm() }
    }

    func fetch(on request: Request, eventID: UUID) -> EventLoopFuture<Event.Form> {
        self.findWithRelationships(on: request, eventID: eventID).toForm()
    }

    func update(on request: Request, form: Event.UpdateForm, eventID: UUID) -> EventLoopFuture<Event.Form> {
        self.findWithRelationships(on: request, eventID: eventID).throwingFlatMap { event in
            event.name = form.name
            event.description = form.description

            return event.save(on: request.db).transform(to: event)
        }.throwingFlatMap { event in
            try self.update(trackers: form.trackerIDs, on: request, for: event).transform(to: event)
        }.throwingFlatMap { (event: Event) in
            var futures: [EventLoopFuture<Void>] = []

            if let updateParameters = form.updateParameters {
                futures.append(self.update(parameters: updateParameters, on: request, for: event))
            }

            if let deleteParameters = form.deleteParameters {
                let parameters = try event.parameters.filter { try deleteParameters.contains($0.requireID()) }

                futures.append(self.parameterService.delete(on: request, parameters: parameters))
            }

            if let createParameters = form.createParameters {
                let createFuture = try createParameters.map {
                    try self.parameterService.create(on: request, form: $0, eventID: event.requireID())
                }.flatten(on: request.eventLoop).transform(to: Void())

                futures.append(createFuture)
            }

            return futures.flatten(on: request.eventLoop).transform(to: event)
        }.flatMap { (event: Event) in
            self.findWithRelationships(on: request, eventID: eventID).map { $0.toForm() }
        }
    }

    func delete(on request: Request, eventID: UUID) -> EventLoopFuture<Void> {
        self.findWithRelationships(on: request, eventID: eventID).flatMap { $0.delete(on: request.db) }
    }
}
