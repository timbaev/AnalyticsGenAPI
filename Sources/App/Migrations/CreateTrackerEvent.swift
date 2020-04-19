//
//  CreateTrackerEvent.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent

struct CreateTrackerEvent: Migration {

    // MARK: - Migration

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TrackerEvent.schema)
            .id()
            .field(TrackerEvent.Fields.trackerID, .uuid, .required, .references(Tracker.schema, .id))
            .field(TrackerEvent.Fields.eventID, .uuid, .required, .references(Event.schema, .id))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TrackerEvent.schema).delete()
    }
}
