//
//  TableableExtension.swift
//  App
//
//  Created by Timur Shafigullin on 11/01/2020.
//

import SwifQL
import Vapor
import FluentPostgreSQL

extension Tableable where Self: Pivot {

    // MARK: - Instance Properties

    public static var entity: String {
        return self.name
    }
}
