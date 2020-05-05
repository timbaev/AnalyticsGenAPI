//
//  AbortExtension.swift
//  App
//
//  Created by Timur Shafigullin on 03/05/2020.
//

import Vapor

extension Abort {

    // MARK: - Type Methods

    static func notFound<Model, ID: CustomStringConvertible>(model: Model.Type, for id: ID) -> Abort {
        Abort(.badRequest, reason: "\(model) with id '\(id)' not found")
    }
}
