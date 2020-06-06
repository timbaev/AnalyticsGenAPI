//
//  EnvironmentExtensions.swift
//  App
//
//  Created by Timur Shafigullin on 02/02/2019.
//

import Vapor

extension Environment {
    
    // MARK: - Type Properties
    
    static var PUBLIC_URL: String {
        Environment.get("PUBLIC_URL") ?? "http://localhost:\(Environment.PORT)"
    }
    
    static var PORT: Int {
        Int(Environment.get("PORT") ?? "8080") ?? -1
    }

    static var DATABASE_URL: String? {
        Environment.get("DATABASE_URL")
    }

    // MARK: - Type Methods

    static func smtpEmail() throws -> String {
        try Environment.get(.smtpEmail).unwrap(or: Abort.requiredEnvironmentVariable(.smtpEmail))
    }

    static func smtpPassword() throws -> String {
        try Environment.get(.smtpPassword).unwrap(or: Abort.requiredEnvironmentVariable(.smtpPassword))
    }

    static func developerEmail() throws -> String {
        try Environment.get(.developerEmail).unwrap(or: Abort.requiredEnvironmentVariable(.developerEmail))
    }
}

// MARK: - Constants

private extension String {

    // MARK: - Type Properties

    static let smtpEmail = "SMTP_EMAIL"
    static let smtpPassword = "SMTP_PASSWORD"
    static let developerEmail = "DEVELOPER_EMAIL"
}
