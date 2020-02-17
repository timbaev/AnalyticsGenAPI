//
//  AnalyticsParameterMigration17022020.swift
//  App
//
//  Created by Timur Shafigullin on 17/02/2020.
//

import Vapor
import FluentPostgreSQL

struct AnalyticsParameterMigration17022020: Migration {

    // MARK: - Typealiases

    typealias Database = PostgreSQLDatabase

    // MARK: - Type Methods

    static func prepare(on connection: Database.Connection) -> Future<Void> {
        return Database.update(AnalyticsParameter.self, on: connection, closure: { builder in
            builder.field(for: \.type)
            builder.field(for: \.isOptional)
        })
    }

    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.update(AnalyticsParameter.self, on: connection, closure: { builder in
            builder.deleteField(for: \.type)
            builder.deleteField(for: \.isOptional)
        })
    }
}
