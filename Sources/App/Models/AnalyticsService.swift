//
//  AnalyticsService.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor
import FluentPostgreSQL

final class AnalyticsService: Object {

    // MARK: - Instance Properties

    var id: Int?
    var name: String

    // MARK: - Initializers

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
