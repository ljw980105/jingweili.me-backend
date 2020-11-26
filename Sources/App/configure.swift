import Fluent
import FluentSQLiteDriver
import Vapor

/// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Register middleware
    app.middleware.use(ErrorMiddleware.default(environment: app.environment))
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    FeatureFlags.default.configureMiddlewaresFrom(app: app)

    // Configure a SQLite database
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // Configure migrations
    let migratables: [Migratable.Type] = [
        AboutInfo.self,
        BeatslyticsData.self,
        //PCSetupEntry.self,
        Experience.self,
        AppsData.self,
        GraphicProject.self,
        Project.self,
        ResumeData.self
    ]
    
    migratables.forEach { migratable in
        app.migrations.add(migratable.createMigration())
    }
    
    app.migrations.add(PCSetupEntryMigrator())
    
    app.logger.logLevel = .debug
    
    //try app.autoMigrate().wait()
    
    currentDirectory = app.directory.workingDirectory
    
    try routes(app)
}
