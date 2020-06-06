//
//  DefaultEmailService.swift
//  App
//
//  Created by Timur Shafigullin on 05/06/2020.
//

import Vapor
import Smtp

struct DefaultEmailService: EmailService {

    // MARK: - Instance Properties

    let templateRenderer: TemplateRenderer

    // MARK: - EmailService

    func sendEventCreatedEmail(on request: Request, event: Event) throws -> EventLoopFuture<Void> {
        let parameters = event.parameters.map { parameter in
            """
            Название: \(parameter.name)<br>
            Описание: \(parameter.description)<br>
            Тип: \(parameter.type.rawValue)<br>
            Обазятельность: \(parameter.isOptional ? "Нет" : "Да")<br>
            """
        }.joined(separator: "<br>")

        let context = EventContext(
            eventName: event.name,
            eventDescription: event.description,
            trackerNames: event.trackers.map { $0.name }.joined(separator: ","),
            parameters: parameters
        )

        return self.templateRenderer.render(
            on: request,
            templateName: "EventTable",
            context: context
        ).throwingFlatMap { body -> EventLoopFuture<Result<Bool, Error>> in
            let email = try Email(
                from: .senderEmailAddress(),
                to: [.developerAddress()],
                subject: "Новое событие",
                body: body,
                isBodyHtml: true
            )

            return request.smtp.send(email)
        }.map { result in
            switch result {
            case .success:
                request.logger.info("sendEventCreatedEmail() -> Success")

            case .failure(let error):
                request.logger.error("sendEventCreatedEmail() -> Error: \(error)")
            }

            return Void()
        }
    }
}

// MARK: - Constants

private extension EmailAddress {

    // MARK: - Type Methods

    static func senderEmailAddress() throws -> EmailAddress {
        try EmailAddress(address: Environment.smtpEmail(), name: "AnalyticsGen")
    }

    static func developerAddress() throws -> EmailAddress {
        try EmailAddress(address: Environment.developerEmail())
    }
}
