//
//  GenerationFormContent.swift
//  App
//
//  Created by Timur Shafigullin on 04/03/2020.
//

import Vapor

struct GenerationFormContent: Content {

    // MARK: - Instance Properties

    let trackers: [Tracker.Form]
    let events: [Event.GenForm]
}
