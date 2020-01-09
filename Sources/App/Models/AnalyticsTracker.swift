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

        // MARK: - Initializers

        init(tracker: AnalyticsTracker) {
            self.id = tracker.id
            self.name = tracker.name
        }
    }

    // MARK: - Instance Properties

    var id: Int?
    var name: String

    // MARK: - Initializers

    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - Future

extension Future where T: AnalyticsTracker {

    // MARK: - Instance Methods

    func toForm() -> Future<AnalyticsTracker.Form> {
        return self.map(to: AnalyticsTracker.Form.self, { tracker in
            return AnalyticsTracker.Form(tracker: tracker)
        })
    }
}
