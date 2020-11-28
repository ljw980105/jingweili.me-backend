//
//  AppsController.swift
//  App
//
//  Created by Jing Wei Li on 6/26/20.
//

import Foundation
import Vapor
import Fluent

struct AppsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // MARK: - Apps: General
        routes.post("api", "apps") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return req
                .deleteAllOnType(AppsData.self, beforeDeleteCallback: { appsData in
                    appsData.forEach { appsDatum in
                        (appsDatum.apps + appsDatum.skills)
                            .forEach { try? deleteFileNamed($0.imageLink, at: .public)}
                    }
                })
                .flatMapThrowing { _ -> EventLoopFuture<Void> in // save
                    let appData = try req.content.decode(AppsData.self)
                    return appData.save(on: req.db)
                }
                .transform(to: req.eventLoop.future(ServerResponse.defaultSuccess))
        }
        
        routes.get("api", "apps") { req -> EventLoopFuture<AppsData> in
            return AppsData
                .query(on: req.db)
                .first()
                .unwrap(orError: NSError(domain: "No Apps Data Exist", code: 0))
        }
        
        // MARK: - Beatslytics
        routes.post("api", "apps", "beatslytics") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return req
                .deleteAllOnType(BeatslyticsData.self)
                .decodeAndSaveOnType(BeatslyticsData.self, req: req)
        }
        
        routes.get("api", "apps", "beatslytics") { req -> EventLoopFuture<BeatslyticsData> in
            return BeatslyticsData
                .query(on: req.db)
                .first()
                .unwrap(orError: NSError(domain: "No BeatslyticsData Exist", code: 0))
        }
    }
}
