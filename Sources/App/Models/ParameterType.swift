//
//  ParameterType.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent
import FluentPostgresDriver
import Vapor

enum ParameterType: String, Codable, CaseIterable {

    // MARK: - Nested Types

    struct Form: Content {

        // MARK: - Instance Properties

        let types: [String]
    }

    // MARK: - Type Properties

    static var name: FieldKey {
        "parameter_type"
    }

    // MARK: - Enumeration Cases

    case int = "Int"
    case float = "Float"
    case double = "Double"
    case bool = "Bool"
    case string = "String"
}
