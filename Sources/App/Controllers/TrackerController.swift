//
//  TrackerController.swift
//  App
//
//  Created by Timur Shafigullin on 19/04/2020.
//

import Vapor

final class TrackerController {

    // MARK: - Instance Methods

    private func create(on request: Request, form: Tracker.Form) -> EventLoopFuture<Tracker.Form> {
        request.trackerService.create(on: request, form: form)
    }

    private func fetch(on request: Request) -> EventLoopFuture<[Tracker.Form]> {
        request.trackerService.fetch(on: request)
    }

    private func fetchForGen(on request: Request) -> EventLoopFuture<GenerationFormContent> {
        request.trackerService.fetchForGen(on: request)
    }
}

// MARK: - RouteCollection

extension TrackerController: RouteCollection {

    // MARK: - Instance Methods

    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("v1", "tracker")

        group.post(use: { request -> EventLoopFuture<Tracker.Form> in
            let form = try request.content.decode(Tracker.Form.self)

            return self.create(on: request, form: form)
        })

        group.get(use: { request -> EventLoopFuture<[Tracker.Form]> in
            self.fetch(on: request)
        })

        group.get("generation", use: { request -> EventLoopFuture<GenerationFormContent> in
            self.fetchForGen(on: request)
        })
    }
}
