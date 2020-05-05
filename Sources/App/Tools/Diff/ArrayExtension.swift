//
//  ArrayExtension.swift
//  App
//
//  Created by Timur Shafigullin on 02/05/2020.
//

import Foundation

extension Array where Self.Element: Equatable {

    // MARK: - Instance Methods

    private func diffIterativeBase<T1, T2>(
        _ first: [T1],
        _ second: [T2],
        with compare: (_ first: T1, _ second: T2) -> Bool,
        with compare2: (T2,T2) -> Bool
    ) -> SequenceDiff<T1, T2> {
        if first.isEmpty {
            return SequenceDiff(inserted: second)
        }

        if second.isEmpty {
            return SequenceDiff(removed: first)
        }

        var common: [(T1, T2)] = []
        var removed: [T1] = []
        var inserted: [T2] = []
        var handledJ: [T2] = []

        outer: for i in first {
            for j in second {
                if compare(i, j) {
                    common.append((i, j))
                    handledJ.append(j)
                    continue outer
                }
            }
            removed.append(i)
        }

        for j in second {
            if handledJ.contains(where: { compare2($0, j) }) {
                continue
            }

            inserted.append(j)
        }

        return SequenceDiff(common: common, removed: removed, inserted: inserted)
    }

    // MARK: -

    func diffIterative<T2: Equatable>(
        _ second: [T2],
        with compare: (Element, T2) -> Bool
    ) -> SequenceDiff<Element, T2> {
        diffIterativeBase(self, second, with: compare, with: ==)
    }
}
