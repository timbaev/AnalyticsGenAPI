//
//  DefaultAnalyticsEventService.swift
//  App
//
//  Created by Timur Shafigullin on 10/01/2020.
//

import Vapor
import FluentPostgreSQL
import SwifQL
import SwifQLVapor

struct DefaultAnalyticsEventService: AnalyticsEventService {

    // MARK: - Instance Methods

    private func isEventExists(on request: Request, with name: String) -> Future<Bool> {
        return SwifQL
            .select
            .exists(SwifQL.select(1).from(AnalyticsEvent.table).where(\AnalyticsEvent.name == name))
            .execute(on: request, as: .psql)
            .first(decoding: ExistsSQL.self)
            .map { $0?.exists ?? false }
    }

    // MARK: - AnalyticsEventService

    func create(on request: Request, form: AnalyticsEvent.CreateForm) throws -> Future<AnalyticsEvent.Form> {
        return self.isEventExists(on: request, with: form.name).flatMap { exists in
            guard !exists else {
                throw Abort(.badRequest, reason: "Event with name '\(form.name)' already exists")
            }

            return AnalyticsEvent(name: form.name, description: form.description).save(on: request).flatMap { analyticsEvent in
                return AnalyticsTrackerEvent(trackerID: form.trackerID, eventID: try analyticsEvent.requireID())
                    .save(on: request)
                    .flatMap { _ in try analyticsEvent.toForm(on: request) }
            }
        }
    }

    func fetch(on request: Request) throws -> Future<[AnalyticsEvent.Form]> {
        AnalyticsEvent.query(on: request).all().flatMap { events in
            try events.map { try $0.toForm(on: request) }.flatten(on: request)
        }
    }
}
