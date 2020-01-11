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

        // MARK: - Initializers

        init(analyticsEvent: AnalyticsEvent) {
            self.id = analyticsEvent.id
            self.name = analyticsEvent.name
            self.description = analyticsEvent.description
        }
    }

    // MARK: -

    struct CreateForm: Content {

        // MARK: - Instance Properties

        let name: String
        let description: String
        let trackerID: AnalyticsTracker.ID
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
}

// MARK: - Future

extension Future where T: AnalyticsEvent {

    // MARK: - Instance Methods

    func toForm() -> Future<AnalyticsEvent.Form> {
        return self.map(to: AnalyticsEvent.Form.self, { event in
            return AnalyticsEvent.Form(analyticsEvent: event)
        })
    }
}
