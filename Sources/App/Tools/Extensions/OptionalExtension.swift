//
//  OptionalExtension.swift
//  App
//
//  Created by Timur Shafigullin on 02/05/2020.
//

import Foundation

extension Optional {

    // MARK: - Instance Methods

    func unwrap(or error: @autoclosure () -> Error) throws -> Wrapped {
        guard let wrapped = self else {
            throw error()
        }

        return wrapped
    }
}
