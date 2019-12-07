//
//  Object.swift
//  App
//
//  Created by Timur Shafigullin on 02/02/2019.
//

import Vapor
import FluentPostgreSQL
import Crypto

public typealias DatabaseType = PostgreSQLDatabase

public typealias IDType = Int

public protocol Object: Model, Parameter, Content, Migration where ID == IDType, Database == DatabaseType {
    
    // MARK: - Instance Properties
    
    var id: ID? { get set }
    
    // MARK: -
    
    static var idKey: WritableKeyPath<Self, ID?> { get }
    
    static var path: [PathComponentsRepresentable] { get }
}

// MARK: -

extension Object {
    
    // MARK: - Instance Properties
    
    public static var idKey: WritableKeyPath<Self, ID?> {
        return \Self.id
    }
    
    public static var path: [PathComponentsRepresentable] {
        return [String(describing: Self.self).lowercased() + "s"]
    }
}
