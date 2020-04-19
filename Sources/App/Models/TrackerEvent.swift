//
//  TrackerEvent.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent
import FluentPostgresDriver
import Vapor

final class TrackerEvent: Model {

    // MARK: - Type Properties

    static var schema: String {
        "tracker_event"
    }

    // MARK: - Instance Properties

    @ID(key: .id)
    var id: UUID?

    @Parent(key: Fields.trackerID)
    var tracker: Tracker

    @Parent(key: Fields.eventID)
    var event: Event

    // MARK: - Initializers

    init() { }

    init(trackerID: Tracker.IDValue, eventID: Event.IDValue) {
        self.$tracker.id = trackerID
        self.$event.id = eventID
    }
}

// MARK: -

extension TrackerEvent {

    // MARK: - Nested Types

    enum Fields {

        // MARK: - Type Properties

        static let trackerID: FieldKey = "tracker_id"
        static let eventID: FieldKey = "event_id"
    }
}
