//
//  Parameter.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent
import FluentPostgresDriver
import Vapor

final class Parameter: Model {

    // MARK: - Nested Types

    struct Form: Content {

        // MARK: - Instance Properties

        let id: UUID?
        let name: String
        let description: String
        let type: String
        let isOptional: Bool

        // MARK: - Initializers

        init(parameter: Parameter) {
            self.id = parameter.id
            self.name = parameter.name
            self.description = parameter.description
            self.type = parameter.type.rawValue
            self.isOptional = parameter.isOptional
        }
    }

    // MARK: -

    struct UpdateForm: Content {

        // MARK: - Instance Properties

        let id: UUID
        let name: String
        let description: String
        let type: ParameterType
        let isOptional: Bool
    }

    // MARK: - Type Properties

    static var schema: String {
        "parameters"
    }

    // MARK: - Instance Properties

    @ID()
    var id: UUID?

    @Field(key: Fields.name)
    var name: String

    @Field(key: Fields.description)
    var description: String

    @Enum(key: Fields.type)
    var type: ParameterType

    @Field(key: Fields.isOptional)
    var isOptional: Bool

    @Parent(key: Fields.eventID)
    var event: Event

    // MARK: - Initializers

    init(
        id: UUID? = nil,
        name: String,
        description: String,
        type: ParameterType,
        isOptional: Bool,
        eventID: Event.IDValue
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.isOptional = isOptional
        self.$event.id = eventID
    }

    init() { }
}

// MARK: -

extension Parameter {

    // MARK: - Nested Types

    enum Fields {

        // MARK: - Type Properties

        static let name: FieldKey = "name"
        static let description: FieldKey = "description"
        static let type: FieldKey = "type"
        static let isOptional: FieldKey = "is_optional"
        static let eventID: FieldKey = "event_id"
    }
}

// MARK: -

extension Parameter {

    // MARK: - Instance Methods

    func toForm() -> Parameter.Form {
        Form(parameter: self)
    }
}

// MARK: - EventLoopFuture

extension EventLoopFuture where Value: Parameter {

    // MARK: - Instance Methods

    func toForm() -> EventLoopFuture<Value.Form> {
        self.map { $0.toForm() }
    }
}
