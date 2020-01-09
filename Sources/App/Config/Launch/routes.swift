import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // MARK: - AnalyticsTrackerController

    let analyticsTrackerController = AnalyticsTrackerController(analyticsTrackerService: AGServices.analyticsTrackerService)

    try router.register(collection: analyticsTrackerController)
}