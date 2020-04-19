//
//  EventController.swift
//  App
//
//  Created by Timur Shafigullin on 19/04/2020.
//

import Vapor

final class EventController {

    // MARK: - Instance Methods

    private func create(on request: Request, form: Event.CreateForm) -> EventLoopFuture<Event.Form> {
        request.eventService.create(on: request, form: form)
    }

    private func fetch(on request: Request) -> EventLoopFuture<[Event.Form]> {
        request.eventService.fetch(on: request)
    }
}

// MARK: - RouteCollection

extension EventController: RouteCollection {

    // MARK: - Instance Methods

    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("v1", "event")

        group.post(use: { request -> EventLoopFuture<Event.Form> in
            let form = try request.content.decode(Event.CreateForm.self)

            return self.create(on: request, form: form)
        })

        group.get(use: { request -> EventLoopFuture<[Event.Form]> in
            self.fetch(on: request)
        })
    }
}
