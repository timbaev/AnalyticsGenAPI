//
//  AnalyticsTrackerMigration17022020.swift
//  App
//
//  Created by Timur Shafigullin on 17/02/2020.
//

import Vapor
import FluentPostgreSQL

struct AnalyticsTrackerMigration17022020: Migration {

    // MARK: - Typealiases

    typealias Database = PostgreSQLDatabase

    // MARK: - Type Methods

    static func prepare(on connection: Database.Connection) -> Future<Void> {
        return Database.update(AnalyticsTracker.self, on: connection, closure: { builder in
            builder.field(for: \.import)
        })
    }

    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.update(AnalyticsTracker.self, on: connection, closure: { builder in
            builder.deleteField(for: \.import)
        })
    }
}
