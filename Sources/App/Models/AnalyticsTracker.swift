//
//  AnalyticsTracker.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor
import FluentPostgreSQL

final class AnalyticsTracker: Object {

    // MARK: - Nested Types

    struct Form: Content {

        // MARK: - Instance Properties

        let id: Int?
        let name: String
        let `import`: String
        let events: [AnalyticsEvent.Form]?

        // MARK: - Initializers

        init(tracker: AnalyticsTracker, events: [AnalyticsEvent.Form]? = nil) {
            self.id = tracker.id
            self.name = tracker.name
            self.import = tracker.import
            self.events = events
        }
    }

    // MARK: - Instance Properties

    var id: Int?
    var name: String
    var `import`: String

    // MARK: - Initializers

    init(id: Int? = nil, name: String, `import`: String) {
        self.id = id
        self.name = name
        self.import = `import`
    }
}

// MARK: - Relationships

extension AnalyticsTracker {

    // MARK: - Instance Properties

    var events: Siblings<AnalyticsTracker, AnalyticsEvent, AnalyticsTrackerEvent> {
        return self.siblings()
    }
}

// MARK: - Future

extension Future where T: AnalyticsTracker {

    // MARK: - Instance Methods

    func toForm(on request: Request) -> Future<AnalyticsTracker.Form> {
        return self.flatMap { try $0.toForm(on: request) }
    }

    func toForm() -> Future<AnalyticsTracker.Form> {
        return self.map { AnalyticsTracker.Form(tracker: $0) }
    }
}

// MARK: -

extension AnalyticsTracker {

    // MARK: - Instance Methods

    func toForm(on request: Request) throws -> Future<AnalyticsTracker.Form> {
        return try self.events.query(on: request).all().flatMap { events in
            return try events.map { try $0.toForm(on: request) }.flatten(on: request)
        }.map { events in
            return AnalyticsTracker.Form(tracker: self, events: events)
        }
    }

    func toForm() -> AnalyticsTracker.Form {
        return AnalyticsTracker.Form(tracker: self)
    }
}
