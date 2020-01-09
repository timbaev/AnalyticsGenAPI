//
//  AnalyticsTrackerService.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor

protocol AnalyticsTrackerService {

    // MARK: - Instance Methods

    func create(on request: Request, form: AnalyticsTracker.Form) throws -> Future<AnalyticsTracker.Form>
}
