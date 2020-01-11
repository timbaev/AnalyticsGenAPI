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
        return try self.analyticsEventService.create(on: request, form: form)
    }
}

// MARK: - RouteCollection

extension AnalyticsEventController: RouteCollection {

    // MARK: - Instance Methods

    func boot(router: Router) throws {
        let group = router.grouped("v1", "event")

        group.post(AnalyticsEvent.CreateForm.self, use: self.create)
    }
}
