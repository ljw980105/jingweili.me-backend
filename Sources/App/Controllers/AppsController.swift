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
    func boot(router: Router) throws {
        // MARK: - Apps: General
        router.post("api", "apps") { req -> Future<ServerResponse> in
            try req.authenticate()
            return req
                .deleteAllOnType(AppsData.self, beforeDeleteCallback: { appsData in
                    appsData.forEach { appsDatum in
                        (appsDatum.apps + appsDatum.skills)
                            .forEach { try? deleteFileNamed($0.imageLink, isPublic: true)}
                    }
                })
                .flatMap { _ -> Future<AppsData> in // save
                    return try req.content
                        .decode(AppsData.self)
                        .flatMap { $0.save(on: req) }
                }
                .transform(to: req.future(ServerResponse.defaultSuccess))
        }
        
        router.get("api", "apps") { req -> Future<AppsData> in
            return AppsData.query(on: req).all()
                .map { apps -> AppsData in
                    guard let first = apps.first else {
                        throw NSError(domain: "No Apps Data Exist", code: 0)
                    }
                    return first
                }
        }
        
        // MARK: - Beatslytics
        router.post("api", "apps", "beatslytics") { req -> Future<ServerResponse> in
            try req.authenticate()
            return req
                .deleteAllOnType(BeatslyticsData.self)
                .decodeAndSaveOnType(BeatslyticsData.self, req: req)
        }
        
        router.get("api", "apps", "beatslytics") { req -> Future<BeatslyticsData> in
            return BeatslyticsData.query(on: req).all()
                .map { apps -> BeatslyticsData in
                    guard let first = apps.first else {
                        throw NSError(domain: "No BeatslyticsData Exist", code: 0)
                    }
                    return first
                }
        }
    }
}
