//
//  DefaultParameterService.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent
import FluentPostgresDriver
import Vapor

struct DefaultParameterService: ParameterService {

    // MARK: - Instance Methods

    private func isParameterExists(
        on request: Request,
        with name: String,
        eventID: Event.IDValue
    ) -> EventLoopFuture<Bool> {
        Parameter.query(on: request.db).filter(\.$name == name).with(\.$event).all().map { parameters in
            parameters.contains(where: { $0.event.id == eventID })
        }
    }

    // MARK: - ParameterService

    func create(
        on request: Request,
        form: Parameter.Form,
        eventID: Event.IDValue
    ) -> EventLoopFuture<Parameter.Form> {
        self.isParameterExists(on: request, with: form.name, eventID: eventID).flatMapThrowing { isExists in
            guard !isExists else {
                throw Abort(.badRequest, reason: "Parameter with name '\(form.name)' in event already exists")
            }

            guard let type = ParameterType(rawValue: form.type) else {
                throw Abort(.badRequest, reason: "Invalid type: '\(form.type)'")
            }

            return Parameter(
                name: form.name,
                description: form.description,
                type: type,
                isOptional: form.isOptional,
                eventID: eventID
            )
        }.flatMap { (parameter: Parameter) in
            parameter.save(on: request.db).transform(to: parameter.toForm())
        }
    }

    func fetch(on request: Request) -> EventLoopFuture<[Event.Form]> {
        Event.query(on: request.db).with(\.$parameters).with(\.$trackers).all().mapEach { $0.toForm() }
    }
}
