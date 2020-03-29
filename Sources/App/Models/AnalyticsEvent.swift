//
//  AnalyticsEvent.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor
import FluentPostgreSQL

final class AnalyticsEvent: Object {

    // MARK: - Nested Types

    struct Form: Content {

        // MARK: - Instance Properties

        let id: Int?
        let name: String
        let description: String
        let analyticsTrackers: [AnalyticsTracker.Form]
        let parameters: [AnalyticsParameter.Form]?

        // MARK: - Initializers

        init(
            analyticsEvent: AnalyticsEvent,
            analyticsTrackers: [AnalyticsTracker.Form],
            parameters: [AnalyticsParameter.Form]? = nil
        ) {
            self.id = analyticsEvent.id
            self.name = analyticsEvent.name
            self.description = analyticsEvent.description
            self.analyticsTrackers = analyticsTrackers
            self.parameters = parameters
        }
    }

    // MARK: -

    struct CreateForm: Content {

        // MARK: - Instance Properties

        let name: String
        let description: String
        let trackerID: AnalyticsTracker.ID
    }

    // MARK: -

    struct GenForm: Content {

        // MARK: - Instance Properties

        let id: Int?
        let name: String
        let description: String
        let parameters: [AnalyticsParameter.Form]
        let trackerNames: [String]

        // MARK: - Initializers

        init(analyticsEvent: AnalyticsEvent, parameters: [AnalyticsParameter.Form], trackerNames: [String]) {
            self.id = analyticsEvent.id
            self.name = analyticsEvent.name
            self.description = analyticsEvent.description
            self.parameters = parameters
            self.trackerNames = trackerNames
        }
    }

    // MARK: - Instance Properties

    var id: Int?
    var name: String
    var description: String

    // MARK: - Initializers

    init(id: Int? = nil, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}

// MARK: - Relationships

extension AnalyticsEvent {

    // MARK: - Instance Properties

    var parameters: Children<AnalyticsEvent, AnalyticsParameter> {
        return self.children(\.analyticsEventID)
    }

    var trackers: Siblings<AnalyticsEvent, AnalyticsTracker, AnalyticsTrackerEvent> {
        return self.siblings()
    }
}

// MARK: - Future

extension Future where T: AnalyticsEvent {

    // MARK: - Instance Methods

    func toForm(on request: Request) -> Future<AnalyticsEvent.Form> {
        return self.flatMap { event in
            return try event.toForm(on: request)
        }
    }
}

// MARK: -

extension AnalyticsEvent {

    // MARK: - Instance Methods

    func toForm(on request: Request) throws -> Future<AnalyticsEvent.Form> {
        let parametersFuture = try self.parameters.query(on: request).all()
        let trackersFuture = try self.trackers.query(on: request).all()

        return parametersFuture.and(trackersFuture).map { parameters, trackers in
            let parameterForms = parameters.map { $0.toForm() }
            let trackerForms = trackers.map { $0.toForm() }

            return AnalyticsEvent.Form(
                analyticsEvent: self,
                analyticsTrackers: trackerForms,
                parameters: parameterForms
            )
        }
    }

    func toGenForm(on request: Request) throws -> Future<AnalyticsEvent.GenForm> {
        return try self.parameters.query(on: request).all().flatMap { parameters in
            let parameterForms = parameters.map { AnalyticsParameter.Form(analyticsParameter: $0) }

            return try self.trackers.query(on: request).all().map { trackers in
                let trackerNames: [String] = trackers.map { $0.name }

                return AnalyticsEvent.GenForm(
                    analyticsEvent: self,
                    parameters: parameterForms,
                    trackerNames: trackerNames
                )
            }
        }
    }
}
