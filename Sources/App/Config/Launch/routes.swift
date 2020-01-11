import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // MARK: - AnalyticsTrackerController

    let analyticsTrackerController = AnalyticsTrackerController(analyticsTrackerService: AGServices.analyticsTrackerService)

    try router.register(collection: analyticsTrackerController)

    // MARK: - AnalyticsEventController

    let analyticsEventController = AnalyticsEventController(analyticsEventService: AGServices.analyitcsEventService)

    try router.register(collection: analyticsEventController)

    // MARK: - AnalyticsParameterController

    let analyticsParameterController = AnalyticsParameterController(analyticsParameterService: AGServices.analyticsParametersSevice)

    try router.register(collection: analyticsParameterController)
}
