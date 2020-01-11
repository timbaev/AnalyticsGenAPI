//
//  AnalyticsParameter.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor
import FluentPostgreSQL

final class AnalyticsParameter: Object {

    // MARK: - Nested Types

    struct Form: Content {

        // MARK: - Instance Properties

        let id: Int?
        let name: String
        let description: String
        let eventID: Int

        // MARK: - Initializers

        init(analyticsParameter: AnalyticsParameter) {
            self.id = analyticsParameter.id
            self.name = analyticsParameter.name
            self.description = analyticsParameter.description
            self.eventID = analyticsParameter.analyticsEventID
        }
    }

    // MARK: - Instance Properties

    var id: Int?
    var name: String
    var description: String

    var analyticsEventID: AnalyticsEvent.ID

    // MARK: - Initializers

    init(id: Int? = nil, name: String, description: String, analyticsEventID: AnalyticsEvent.ID) {
        self.id = id
        self.name = name
        self.description = description
        self.analyticsEventID = analyticsEventID
    }
}

// MARK: - Relationships

extension AnalyticsParameter {

    // MARK: - Instance Properties

    var event: Parent<AnalyticsParameter, AnalyticsEvent> {
        return self.parent(\.analyticsEventID)
    }
}

// MARK: - Migration

extension AnalyticsParameter {

    // MARK: - Type Methods

    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(AnalyticsParameter.self, on: connection) { builder in
            try self.addProperties(to: builder)

            builder.reference(from: \.analyticsEventID, to: \AnalyticsEvent.id)
        }
    }
}

// MARK: - Future

extension Future where T: AnalyticsParameter {

    // MARK: - Instance Methods

    func toForm() -> Future<AnalyticsParameter.Form> {
        return self.map(to: AnalyticsParameter.Form.self, { parameter in
            return AnalyticsParameter.Form(analyticsParameter: parameter)
        })
    }
}
