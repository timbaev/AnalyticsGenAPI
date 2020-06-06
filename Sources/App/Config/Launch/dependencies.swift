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
        DefaultEventService(parameterService: self.parameterService, emailService: self.emailService)
    }

    var parameterService: ParameterService {
        DefaultParameterService()
    }

    var trackerService: TrackerService {
        DefaultTrackerService()
    }

    var emailService: EmailService {
        DefaultEmailService(templateRenderer: self.templateRenderer)
    }

    var templateRenderer: TemplateRenderer {
        HTMLTemplateRenderer()
    }
}
