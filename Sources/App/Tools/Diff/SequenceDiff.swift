//
//  SequenceDiff.swift
//  App
//
//  Created by Timur Shafigullin on 02/05/2020.
//

import Foundation

struct SequenceDiff<T1, T2> {

    // MARK: - Instance Properties

    let common: [(T1, T2)]
    let removed: [T1]
    let inserted: [T2]

    // MARK: - Initializers

    init(common: [(T1, T2)] = [], removed: [T1] = [], inserted: [T2] = []) {
        self.common = common
        self.removed = removed
        self.inserted = inserted
    }
}
