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

    private func update(on request: Request, form: Event.UpdateForm, eventID: UUID) -> EventLoopFuture<Event.Form> {
        request.eventService.update(on: request, form: form, eventID: eventID)
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

        group.patch(":id", use: { request -> EventLoopFuture<Event.Form> in
            let form = try request.content.decode(Event.UpdateForm.self)
            let id = try request.parameters.get("id", as: UUID.self).unwrap(or: Abort(.badRequest))

            return self.update(on: request, form: form, eventID: id)
        })
    }
}
