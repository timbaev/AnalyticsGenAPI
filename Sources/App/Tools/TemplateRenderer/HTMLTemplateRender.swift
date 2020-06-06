//
//  HTMLTemplateRenderer.swift
//  App
//
//  Created by Timur Shafigullin on 05/06/2020.
//

import Vapor
import Leaf

struct HTMLTemplateRenderer: TemplateRenderer {

    // MARK: - TemplateRender

    func render<Context: Encodable>(
        on request: Request,
        templateName name: String,
        context: Context
    ) -> EventLoopFuture<String> {
        let renderer = request.application.leaf.renderer

        return renderer.render(name, context).flatMapThrowing { view in
            return String(buffer: view.data)
        }
    }
}
