import Fluent
import FluentMongoDriver
import Vapor

/// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Register middleware
    app.middleware.use(ErrorMiddleware.default(environment: app.environment))
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    Configurations.default.configureMiddlewaresFrom(app: app)

    // Configure MongoDB
    //app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    try app.databases.use(.mongo(connectionString: Configurations.default.mongoURL), as: .mongo)

    // Configure migrations
    let migratables: [Migratable.Type] = [
        AboutInfo.self,
        BeatslyticsData.self,
        PCSetupEntry.self,
        Experience.self,
        AppsData.self,
        GraphicProject.self,
        Project.self,
        ResumeData.self
    ]
    
    migratables.forEach { migratable in
        app.migrations.add(migratable.createMigration())
    }
    
    app.logger.logLevel = .error
    
    currentDirectory = app.directory.workingDirectory
    
    app.routes.defaultMaxBodySize = "50mb"
    
    try routes(app)
}
