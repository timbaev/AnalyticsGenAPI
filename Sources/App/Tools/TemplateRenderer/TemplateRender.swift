//
//  TemplateRender.swift
//  App
//
//  Created by Timur Shafigullin on 05/06/2020.
//

import Vapor

protocol TemplateRenderer {

    // MARK: - Instance Methods

    func render<Context: Encodable>(
        on request: Request,
        templateName name: String,
        context: Context
    ) -> EventLoopFuture<String>
}
