//
//  dependencies.swift
//  App
//
//  Created by Timur Shafigullin on 19/04/2020.
//

import Vapor

extension Request {

    // MARK: - Instance Properties

    var eventService: EventService {
        DefaultEventService(parameterService: self.parameterService)
    }

    var parameterService: ParameterService {
        DefaultParameterService()
    }

    var trackerService: TrackerService {
        DefaultTrackerService()
    }
}
