//
//  AnalyticsEventService.swift
//  App
//
//  Created by Timur Shafigullin on 10/01/2020.
//

import Vapor

protocol AnalyticsEventService {

    // MARK: - Instance Methods

    func create(on request: Request, form: AnalyticsEvent.CreateForm) throws -> Future<AnalyticsEvent.Form>
    func fetch(on request: Request) throws -> Future<[AnalyticsEvent.Form]>
}
