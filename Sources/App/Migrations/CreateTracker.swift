//
//  CreateTracker.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent

struct CreateTracker: Migration {

    // MARK: - Migration

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Tracker.schema)
            .id()
            .field(Tracker.Fields.name, .string, .required)
            .field(Tracker.Fields.import, .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Tracker.schema).delete()
    }
}
