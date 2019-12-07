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
        return Environment.get("PUBLIC_URL") ?? "http://localhost:\(Environment.PORT)"
    }
    
    static var PORT: Int {
        return Int(Environment.get("PORT") ?? "8080") ?? -1
    }

    static var DATABASE_URL: String? {
        return Environment.get("DATABASE_URL")
    }
}
