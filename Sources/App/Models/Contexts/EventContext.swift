//
//  EventContext.swift
//  App
//
//  Created by Timur Shafigullin on 05/06/2020.
//

import Foundation

struct EventContext: Encodable {

    // MARK: - Instance Properties

    let eventName: String
    let eventDescription: String
    let trackerNames: String
    let parameters: String
}
