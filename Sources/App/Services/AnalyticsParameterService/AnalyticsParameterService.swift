//
//  AnalyticsParameterService.swift
//  App
//
//  Created by Timur Shafigullin on 11/01/2020.
//

import Vapor

protocol AnalyticsParameterService {

    // MARK: - Instance Methods

    func create(
        on request: Request,
        form: AnalyticsParameter.Form,
        eventID: AnalyticsEvent.ID
    ) throws -> Future<AnalyticsParameter.Form>
}
