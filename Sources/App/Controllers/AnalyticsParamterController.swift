//
//  AnalyticsParamterController.swift
//  App
//
//  Created by Timur Shafigullin on 11/01/2020.
//

import Vapor

final class AnalyticsParameterController {

    // MARK: - Instance Properties

    let analyticsParameterService: AnalyticsParameterService

    // MARK: - Initializers

    init(analyticsParameterService: AnalyticsParameterService) {
        self.analyticsParameterService = analyticsParameterService
    }

    // MARK: - Instance Methods

    func create(_ request: Request, form: AnalyticsParameter.Form) throws -> Future<AnalyticsParameter.Form> {
        return try self.analyticsParameterService.create(on: request, form: form)
    }

    func fetchParameterTypes(_ request: Request) throws -> Future<AnalyticsParameter.ParameterTypesForm> {
        let types = AnalyticsParameter.ParameterType.allCases.map { $0.rawValue }
        let form = AnalyticsParameter.ParameterTypesForm(types: types)

        return request.future(form)
    }
}

// MARK: - RouteCollection

extension AnalyticsParameterController: RouteCollection {

    // MARK: - Instance Methods

    func boot(router: Router) throws {
        let group = router.grouped("v1", "parameter")

        group.post(AnalyticsParameter.Form.self, use: self.create)
        group.get("types", use: self.fetchParameterTypes)
    }
}
