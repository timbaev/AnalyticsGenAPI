//
//  AnalyticsTrackerViewModel.swift
//  App
//
//  Created by Timur Shafigullin on 09/01/2020.
//

import Foundation

struct AnalyticsTrackerContext: Codable {

    // MARK: - Instance Properties

    let analyticsTrackers: [AnalyticsTracker.Form]
    let columns: [String]
}
