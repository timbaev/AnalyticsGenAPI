//
//  EventLoopFutureExtension.swift
//  App
//
//  Created by Timur Shafigullin on 03/05/2020.
//

import Vapor

extension EventLoopFuture {

    // MARK: - Instance Methods

    func throwingFlatMap<NewValue>(
        _ transform: @escaping (Value) throws -> EventLoopFuture<NewValue>
    ) -> EventLoopFuture<NewValue> {
        self.flatMap { value in
            do {
                return try transform(value)
            } catch {
                return self.eventLoop.makeFailedFuture(error)
            }
        }
    }
}
