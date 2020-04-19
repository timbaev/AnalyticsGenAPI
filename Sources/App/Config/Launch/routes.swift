import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: EventController())
    try app.register(collection: ParameterController())
    try app.register(collection: TrackerController())
}
