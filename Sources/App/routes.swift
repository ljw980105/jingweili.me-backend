import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    try router.register(collection: AuthenticationController())
    try router.register(collection: ResumeController())
    try router.register(collection: GraphicsController())
    try router.register(collection: HomePageController())
    try router.register(collection: ProjectsController())
}
