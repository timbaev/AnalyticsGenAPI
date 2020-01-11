//
//  Services.swift
//  App
//
//  Created by Timur Shafigullin on 07/12/2019.
//

import Foundation

enum AGServices {

    // MARK: - Type Properties

    static let analyticsTrackerService: AnalyticsTrackerService = DefaultAnalyticsTrackerService()
    static let analyitcsEventService: AnalyticsEventService = DefaultAnalyticsEventService()
    static let analyticsParametersSevice: AnalyticsParameterService = DefaultAnalyticsParameterService()
}
