//
//  AnalyticsServiceController.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor

final class AnalyticsTrackerController {

    // MARK: - Instance Properties

    private let analyticsTrackerService: AnalyticsTrackerService

    // MARK: - Initializers

    init(analyticsTrackerService: AnalyticsTrackerService) {
        self.analyticsTrackerService = analyticsTrackerService
    }

    // MARK: - Instance Methods

    func create(_ request: Request, form: AnalyticsTracker.Form) throws -> Future<AnalyticsTracker.Form> {
        return try self.analyticsTrackerService.create(on: request, form: form)
    }

    func fetch(_ request: Request) throws -> Future<[AnalyticsTracker.Form]> {
        return try self.analyticsTrackerService.fetch(on: request)
    }

    func render(_ request: Request) throws -> Future<View> {
        return try self.analyticsTrackerService.fetch(on: request).flatMap { analyticsTrackerForms in
            let context = AnalyticsTrackerContext(analyticsTrackers: analyticsTrackerForms, columns: ["name"])

            return try request.view().render("analyticsTrackerList", context)
        }
    }

    func fetchEvents(_ request: Request) throws -> Future<[AnalyticsEvent.Form]> {
        return try request.parameters.next(AnalyticsTracker.self).flatMap { tracker in
            return try self.analyticsTrackerService.fetchEvents(on: request, tracker: tracker)
        }
    }
}

// MARK: - RouteCollection

extension AnalyticsTrackerController: RouteCollection {

    // MARK: - Instance Methods

    func boot(router: Router) throws {
        let group = router.grouped("v1", "tracker")

        group.post(AnalyticsTracker.Form.self, use: self.create)
        group.get(use: self.fetch)
        group.get("render", use: self.render)
        group.get(AnalyticsTracker.parameter, "events", use: self.fetchEvents)
    }
}
