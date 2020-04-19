//
//  TrackerService.swift
//  App
//
//  Created by Timur Shafigullin on 18/04/2020.
//

import Vapor

protocol TrackerService {

    // MARK: - Instance Methods

    func create(on request: Request, form: Tracker.Form) -> EventLoopFuture<Tracker.Form>
    func fetch(on request: Request) -> EventLoopFuture<[Tracker.Form]>
    func fetchForGen(on request: Request) -> EventLoopFuture<GenerationFormContent>
}
