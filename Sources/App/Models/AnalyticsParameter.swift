//
//  AnalyticsParameter.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor
import FluentPostgreSQL

final class AnalyticsParameter: Object {

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
