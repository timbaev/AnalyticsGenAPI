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

                return AnalyticsTracker(name: form.name).save(on: request).toForm()
        }
    }

    func fetch(on request: Request) throws -> Future<[AnalyticsTracker.Form]> {
        return SwifQL.select(AnalyticsTracker.table.*)
            .from(AnalyticsTracker.table)
            .execute(on: request, as: .psql)
            .all(decoding: AnalyticsTracker.Form.self)
    }

    func fetchEvents(on request: Request, tracker: AnalyticsTracker) throws -> Future<[AnalyticsEvent.Form]> {
        return try SwifQL.select(\AnalyticsEvent.id, \AnalyticsEvent.name, \AnalyticsEvent.description)
            .from(AnalyticsTrackerEvent.table)
            .join(.inner, AnalyticsEvent.table, on: \AnalyticsTrackerEvent.eventID == \AnalyticsEvent.id)
            .where(\AnalyticsTrackerEvent.trackerID == tracker.requireID())
            .execute(on: request, as: .psql)
            .all(decoding: AnalyticsEvent.Form.self)
    }
}
