//
//  DefaultTrackerService.swift
//  App
//
//  Created by Timur Shafigullin on 18/04/2020.
//

import Fluent
import FluentPostgresDriver
import Vapor

struct DefaultTrackerService: TrackerService {

    // MARK: - Instance Methods

    private func isTrackerExists(on request: Request, with name: String) -> EventLoopFuture<Bool> {
        Tracker.query(on: request.db).filter(\.$name == name).first().map { tracker in
            tracker != nil
        }
    }

    // MARK: - TrackerService

    func create(on request: Request, form: Tracker.Form) -> EventLoopFuture<Tracker.Form> {
        self.isTrackerExists(on: request, with: form.name).flatMapThrowing { isExists in
            guard !isExists else {
                throw Abort(.badRequest, reason: "Tracker with name '\(form.name)' already exists")
            }

            return Tracker(name: form.name, import: form.import)
        }.flatMap { (tracker: Tracker) in
            tracker.save(on: request.db).transform(to: tracker.toForm())
        }
    }

    func fetch(on request: Request) -> EventLoopFuture<[Tracker.Form]> {
        Tracker.query(on: request.db).all().mapEach { $0.toForm() }
    }

    func fetchForGen(on request: Request) -> EventLoopFuture<GenerationFormContent> {
        let trackerFormsFuture = self.fetch(on: request)

        let eventFormsFuture = Event.query(on: request.db).with(\.$parameters).with(\.$trackers).all().mapEach {
            $0.toGenForm()
        }

        return trackerFormsFuture.and(eventFormsFuture).map { trackerForms, eventForms in
            GenerationFormContent(trackers: trackerForms, events: eventForms)
        }
    }
}
