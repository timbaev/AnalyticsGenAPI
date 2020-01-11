//
//  DefaultAnalyticsParameterService.swift
//  App
//
//  Created by Timur Shafigullin on 11/01/2020.
//

import Vapor
import SwifQL
import SwifQLVapor

struct DefaultAnalyticsParameterService: AnalyticsParameterService {

    // MARK: - Instance Methods

    private func isParameterExists(on request: Request, with name: String, eventID: AnalyticsEvent.ID) -> Future<Bool> {
        return SwifQL
            .select
            .exists(SwifQL.select(1)
                .from(AnalyticsParameter.table)
                .where(\AnalyticsParameter.name == name)
                .and(\AnalyticsParameter.analyticsEventID == eventID))
            .execute(on: request, as: .psql)
            .first(decoding: ExistsSQL.self)
            .map { $0?.exists ?? false }
    }

    // MARK: - AnalyticsParameterService

    func create(on request: Request, form: AnalyticsParameter.Form) throws -> Future<AnalyticsParameter.Form> {
        return self.isParameterExists(on: request, with: form.name, eventID: form.eventID).flatMap { exists in
            guard !exists else {
                throw Abort(.badRequest, reason: "Parameter with name '\(form.name)' in event already exists")
            }

            return AnalyticsParameter(name: form.name, description: form.description, analyticsEventID: form.eventID)
                .save(on: request)
                .toForm()
        }
    }
}