//
//  ParameterController.swift
//  App
//
//  Created by Timur Shafigullin on 19/04/2020.
//

import Vapor

final class ParameterController {

    // MARK: - Instance Methods

    private func fetchParameterTypes(on request: Request) -> EventLoopFuture<ParameterType.Form> {
        let types = ParameterType.allCases.map { $0.rawValue }
        let form = ParameterType.Form(types: types)

        return request.eventLoop.future(form)
    }
}

// MARK: - RouteCollection

extension ParameterController: RouteCollection {

    // MARK: - Instance Methods

    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("v1", "parameter")

        group.get("types", use: { request -> EventLoopFuture<ParameterType.Form> in
            self.fetchParameterTypes(on: request)
        })
    }
}
