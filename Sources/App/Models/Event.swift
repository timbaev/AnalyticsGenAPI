//
//  Event.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent
import FluentPostgresDriver
import Vapor

final class Event: Model {

    // MARK: - Nested Types

    struct Form: Content {

        // MARK: - Instance Properties

        let id: String?
        let name: String
        let description: String
        let trackers: [Tracker.Form]
        let parameters: [Parameter.Form]

        // MARK: - Initializers

        init(
            analyticsEvent: Event,
            trackers: [Tracker.Form],
            parameters: [Parameter.Form]
        ) {
            self.id = analyticsEvent.id?.uuidString
            self.name = analyticsEvent.name
            self.description = analyticsEvent.description
            self.trackers = trackers
            self.parameters = parameters
        }
    }

    // MARK: -

    struct CreateForm: Content {

        // MARK: - Instance Properties

        let name: String
        let description: String
        let trackerIDs: [Tracker.IDValue]
        let parameters: [Parameter.Form]
    }

    // MARK: -

    struct GenForm: Content {

        // MARK: - Instance Properties

        let id: String?
        let name: String
        let description: String
        let parameters: [Parameter.Form]
        let trackerNames: [String]

        // MARK: - Initializers

        init(analyticsEvent: Event, parameters: [Parameter.Form], trackerNames: [String]) {
            self.id = analyticsEvent.id?.uuidString
            self.name = analyticsEvent.name
            self.description = analyticsEvent.description
            self.parameters = parameters
            self.trackerNames = trackerNames
        }
    }

    // MARK: - Type Properties

    static var schema: String {
        "events"
    }

    // MARK: - Instance Properties

    @ID(key: .id)
    var id: UUID?

    @Field(key: Fields.name)
    var name: String

    @Field(key: Fields.description)
    var description: String

    @Children(for: \.$event)
    var parameters: [Parameter]

    @Siblings(through: TrackerEvent.self, from: \.$event, to: \.$tracker)
    var trackers: [Tracker]

    // MARK: - Initializers

    init(id: UUID? = nil, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }

    init() { }
}

// MARK: -

extension Event {

    // MARK: - Nested Types

    enum Fields {

        // MARK: - Type Properties

        static let name: FieldKey = "name"
        static let description: FieldKey = "description"
    }
}

// MARK: -

extension Event {

    // MARK: - Instance Methods

    func toForm() -> Form {
        Form(
            analyticsEvent: self,
            trackers: self.trackers.map { $0.toForm() },
            parameters: self.parameters.map { $0.toForm() }
        )
    }

    func toGenForm() -> GenForm {
        GenForm(
            analyticsEvent: self,
            parameters: self.parameters.map { $0.toForm() },
            trackerNames: self.trackers.map { $0.name }
        )
    }
}

// MARK: - EventLoopFuture

extension EventLoopFuture where Value: Event {

    // MARK: - Instance Methods

    func toForm() -> EventLoopFuture<Value.Form> {
        self.map { $0.toForm() }
    }

    func toGenForm() -> EventLoopFuture<Value.GenForm> {
        self.map { $0.toGenForm() }
    }
}
