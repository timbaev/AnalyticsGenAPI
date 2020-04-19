//
//  ParameterService.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Vapor

protocol ParameterService {

    // MARK: - Instance Methods
    
    func create(
        on request: Request,
        form: Parameter.Form,
        eventID: Event.IDValue
    ) -> EventLoopFuture<Parameter.Form>

    func fetch(on request: Request) -> EventLoopFuture<[Event.Form]>
}
