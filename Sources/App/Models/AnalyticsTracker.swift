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

        // MARK: - Initializers

        init(tracker: AnalyticsTracker) {
            self.id = tracker.id
            self.name = tracker.name
            self.import = tracker.import
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

    func toForm() -> Future<AnalyticsTracker.Form> {
        self.map { $0.toForm() }
    }
}

// MARK: -

extension AnalyticsTracker {

    // MARK: - Instance Methods

    func toForm() -> AnalyticsTracker.Form {
        AnalyticsTracker.Form(tracker: self)
    }
}
