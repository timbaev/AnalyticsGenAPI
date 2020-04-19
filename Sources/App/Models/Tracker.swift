//
//  Tracker.swift
//  App
//
//  Created by Timur Shafigullin on 11/04/2020.
//

import Fluent
import FluentPostgresDriver
import Vapor

final class Tracker: Model {

    // MARK: - Nested Types

    struct Form: Content {

        // MARK: - Instance Properties

        let id: String?
        let name: String
        let `import`: String

        // MARK: - Initializers

        init(tracker: Tracker) {
            self.id = tracker.id?.uuidString
            self.name = tracker.name
            self.import = tracker.import
        }
    }

    // MARK: - Type Properties

    static var schema: String {
        "trackers"
    }

    // MARK: - Instance Properties

    @ID(key: .id)
    var id: UUID?

    @Field(key: Fields.name)
    var name: String

    @Field(key: Fields.import)
    var `import`: String

    @Siblings(through: TrackerEvent.self, from: \.$tracker, to: \.$event)
    var events: [Event]

    // MARK: - Initializers

    init(id: UUID? = nil, name: String, `import`: String) {
        self.id = id
        self.name = name
        self.import = `import`
    }

    init() { }
}

// MARK: -

extension Tracker {

    // MARK: - Nested Types

    enum Fields {

        // MARK: - Type Properties

        static let name: FieldKey = "name"
        static let `import`: FieldKey = "import"
    }
}

// MARK: -

extension Tracker {

    // MARK: - Instance Methods

    func toForm() -> Form {
        Form(tracker: self)
    }
}

// MARK: - EventLoopFuture

extension EventLoopFuture where Value: Tracker {

    // MARK: - Instance Methods

    func toForm() -> EventLoopFuture<Value.Form> {
        self.map { $0.toForm() }
    }
}
