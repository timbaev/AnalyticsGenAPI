//
//  EmailService.swift
//  App
//
//  Created by Timur Shafigullin on 05/06/2020.
//

import Vapor

protocol EmailService {

    // MARK: - Instance Methods

    func sendEventChangedEmail(on request: Request, event: Event, subject: String) throws -> EventLoopFuture<Void>
    func sendEventDeletedEmail(on request: Request, event: Event) throws -> EventLoopFuture<Void>
}
