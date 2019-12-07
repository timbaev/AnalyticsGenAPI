//
//  AnalyticsServiceEvent.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Vapor
import FluentPostgreSQL

struct AnalyticsServiceEvent: PostgreSQLPivot {

    // MARK: - Nested Types

    typealias Left = AnalyticsService
    typealias Right = AnalyticsEvent

    // MARK: - Type Properties

    static var leftIDKey: LeftIDKey = \.serviceID
    static var rightIDKey: RightIDKey = \.eventID

    // MARK: - Instance Properties

    var id: Int?
    var serviceID: AnalyticsService.ID
    var eventID: AnalyticsEvent.ID

    // MARK: - Initializers

    init(id: Int? = nil, serviceID: AnalyticsService.ID, eventID: AnalyticsEvent.ID) {
        self.id = id
        self.serviceID = serviceID
        self.eventID = eventID
    }
}

// MARK: - ModifiablePivot

extension AnalyticsServiceEvent: ModifiablePivot {

    // MARK: - Initializers

    init(_ left: Self.Left, _ right: Self.Right) throws {
        self.serviceID = try left.requireID()
        self.eventID = try right.requireID()
    }
}

// MARK: - Migration

extension AnalyticsServiceEvent: Migration {

    // MARK: - Type Methods

    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn, closure: { builder in
            try self.addProperties(to: builder)
            builder.reference(from: \.serviceID, to: \AnalyticsService.id, onDelete: .cascade)
            builder.reference(from: \.eventID, to: \AnalyticsEvent.id, onDelete: .cascade)
        })
    }
}
