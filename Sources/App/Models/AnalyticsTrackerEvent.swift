//
//  AnalyticsServiceEvent.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor
import FluentPostgreSQL
import SwifQL

struct AnalyticsTrackerEvent: PostgreSQLPivot {

    // MARK: - Nested Types

    typealias Left = AnalyticsTracker
    typealias Right = AnalyticsEvent

    // MARK: - Type Properties

    static var leftIDKey: LeftIDKey = \.trackerID
    static var rightIDKey: RightIDKey = \.eventID

    // MARK: - Instance Properties

    var id: Int?
    var trackerID: AnalyticsTracker.ID
    var eventID: AnalyticsEvent.ID

    // MARK: - Initializers

    init(id: Int? = nil, trackerID: AnalyticsTracker.ID, eventID: AnalyticsEvent.ID) {
        self.id = id
        self.trackerID = trackerID
        self.eventID = eventID
    }
}

// MARK: - ModifiablePivot

extension AnalyticsTrackerEvent: ModifiablePivot {

    // MARK: - Initializers

    init(_ left: Self.Left, _ right: Self.Right) throws {
        self.trackerID = try left.requireID()
        self.eventID = try right.requireID()
    }
}

// MARK: - Migration

extension AnalyticsTrackerEvent: Migration {

    // MARK: - Type Methods

    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn, closure: { builder in
            try self.addProperties(to: builder)
            builder.reference(from: \.trackerID, to: \AnalyticsTracker.id, onDelete: .cascade)
            builder.reference(from: \.eventID, to: \AnalyticsEvent.id, onDelete: .cascade)
        })
    }
}

// MARK: - Tableable

extension AnalyticsTrackerEvent: Tableable { }
