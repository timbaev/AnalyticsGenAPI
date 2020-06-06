//
//  EmailService.swift
//  App
//
//  Created by Timur Shafigullin on 05/06/2020.
//

import Vapor

protocol EmailService {

    // MARK: - Instance Methods

    @discardableResult
    func sendEventCreatedEmail(on request: Request, event: Event) throws -> EventLoopFuture<Void>
}
