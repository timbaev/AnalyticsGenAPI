//
//  CreateParameter.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent

struct CreateParameter: Migration {

    // MARK: - Migration

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        var enumBuilder = database.enum(ParameterType.name.description)

        ParameterType.allCases.forEach { enumBuilder = enumBuilder.case($0.rawValue) }

        return enumBuilder.create().flatMap { enumType in
            database.schema(Parameter.schema)
                .id()
                .field(Parameter.Fields.name, .string, .required)
                .field(Parameter.Fields.description, .string, .required)
                .field(Parameter.Fields.type, enumType, .required)
                .field(Parameter.Fields.isOptional, .bool, .required)
                .field(Parameter.Fields.eventID, .uuid, .references(Event.schema, .id, onDelete: .cascade))
                .create()
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Parameter.schema).delete()
    }
}
