//
//  AnalyticsEvent.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor
import FluentPostgreSQL

final class AnalyticsEvent: Object {

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
