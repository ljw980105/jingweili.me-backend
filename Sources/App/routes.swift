import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ app: Application) throws {
    try app.register(collection: AuthenticationController())
    try app.register(collection: ResumeController())
    try app.register(collection: GraphicsController())
    try app.register(collection: HomePageController())
    try app.register(collection: ProjectsController())
    try app.register(collection: AppsController())
    try app.register(collection: MiscController())
}
