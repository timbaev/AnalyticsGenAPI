//
//  DefaultAnalyticsTrackerService.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor
import SwifQL
import SwifQLVapor

struct DefaultAnalyticsTrackerService: AnalyticsTrackerService {

    // MARK: - AnalyticsTrackerService

    func create(on request: Request, form: AnalyticsTracker.Form) throws -> Future<AnalyticsTracker.Form> {
        return SwifQL.select(AnalyticsTracker.table.*)
            .from(AnalyticsTracker.table)
            .where(\AnalyticsTracker.name == form.name)
            .limit(1)
            .execute(on: request, as: .psql)
            .all(decoding: AnalyticsTracker.Form.self).flatMap { trackers in
                guard trackers.isEmpty else {
                    throw Abort(.badRequest, reason: "Tracker already exists")
                }

                return AnalyticsTracker(name: form.name, import: form.import).save(on: request).toForm()
        }
    }

    func fetch(on request: Request) throws -> Future<[AnalyticsTracker.Form]> {
        return SwifQL.select(AnalyticsTracker.table.*)
            .from(AnalyticsTracker.table)
            .execute(on: request, as: .psql)
            .all(decoding: AnalyticsTracker.self)
            .flatMap { trackers in try trackers.map { try $0.toForm(on: request) }.flatten(on: request) }
    }

    func fetchForGen(on request: Request) throws -> Future<GenerationFormContent> {
        return SwifQL.select(AnalyticsTracker.table.*)
            .from(AnalyticsTracker.table)
            .execute(on: request, as: .psql).all(decoding: AnalyticsTracker.self)
            .map { trackers in
                trackers.map { $0.toForm() }
            }.then { trackerForms in
                return AnalyticsEvent.query(on: request).all().flatMap { events in
                    return try events.map { try $0.toGenForm(on: request) }.flatten(on: request)
                }.and(result: trackerForms)
            }.map { eventForms, trackerForms in
                return GenerationFormContent(trackers: trackerForms, events: eventForms)
            }
    }
}
