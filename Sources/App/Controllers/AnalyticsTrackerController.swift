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

    func fetchForGen(_ request: Request) throws -> Future<GenerationFormContent> {
        return try self.analyticsTrackerService.fetchForGen(on: request)
    }
}

// MARK: - RouteCollection

extension AnalyticsTrackerController: RouteCollection {

    // MARK: - Instance Methods

    func boot(router: Router) throws {
        let group = router.grouped("v1", "tracker")

        group.post(AnalyticsTracker.Form.self, use: self.create)
        group.get(use: self.fetch)
        group.get("generation", use: self.fetchForGen)
    }
}
