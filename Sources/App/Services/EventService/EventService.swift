//
//  EventService.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Vapor

protocol EventService {

    // MARK: - Instance Methods

    func create(on request: Request, form: Event.CreateForm) -> EventLoopFuture<Event.Form>
    func fetch(on request: Request) -> EventLoopFuture<[Event.Form]>
    func update(on request: Request, form: Event.UpdateForm, eventID: UUID) -> EventLoopFuture<Event.Form>
}
