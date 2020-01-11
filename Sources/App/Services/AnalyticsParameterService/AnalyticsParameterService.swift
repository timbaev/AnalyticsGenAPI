//
//  AnalyticsParameterService.swift
//  App
//
//  Created by Timur Shafigullin on 11/01/2020.
//

import Vapor

protocol AnalyticsParameterService {

    // MARK: - Instance Methods

    func create(on request: Request, form: AnalyticsParameter.Form) throws -> Future<AnalyticsParameter.Form>
}
