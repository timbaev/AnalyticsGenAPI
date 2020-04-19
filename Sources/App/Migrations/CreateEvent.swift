//
//  CreateEvent.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent

struct CreateEvent: Migration {

    // MARK: - Migration

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Event.schema)
            .id()
            .field(Event.Fields.name, .string, .required)
            .field(Event.Fields.description, .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Event.schema).delete()
    }
}
