//
//  AnalyticsEventController.swift
//  App
//
//  Created by Timur Shafigullin on 10/01/2020.
//

import Vapor

final class AnalyticsEventController {

    // MARK: - Instance Properties

    private let analyticsEventService: AnalyticsEventService

    // MARK: - Initializers

    init(analyticsEventService: AnalyticsEventService) {
        self.analyticsEventService = analyticsEventService
    }

    // MARK: - Instance Methods

    func create(_ request: Request, form: AnalyticsEvent.CreateForm) throws -> Future<AnalyticsEvent.Form> {
        try self.analyticsEventService.create(on: request, form: form)
    }

    func fetch(_ request: Request) throws -> Future<[AnalyticsEvent.Form]> {
        try self.analyticsEventService.fetch(on: request)
    }
}

// MARK: - RouteCollection

extension AnalyticsEventController: RouteCollection {

    // MARK: - Instance Methods

    func boot(router: Router) throws {
        let group = router.grouped("v1", "event")

        group.post(AnalyticsEvent.CreateForm.self, use: self.create)
        group.get(use: self.fetch)
    }
}
