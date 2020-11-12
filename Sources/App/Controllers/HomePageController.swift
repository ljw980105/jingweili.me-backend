//
//  HomePageController.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor
import Fluent

struct HomePageController: RouteCollection {
    func boot(router: Router) throws {
        // MARK: - PC Entries
        router.post("api", "pc-setup") { req -> Future<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(PCSetupEntry.self)
                .flatMap { _ -> Future<[PCSetupEntry]> in
                    return try req.content
                    .decode([PCSetupEntry].self)
                    .flatMap(to: [PCSetupEntry].self) { $0.save(on: req) }
                }
                .transform(to: ServerResponse.defaultSuccess)
        }
        
        router.get("api", "pc-setup") { req -> Future<[PCSetupEntry]> in
            return PCSetupEntry.query(on: req).all()
        }
        
        // MARK: - About
        router.post("api", "about-info") { req -> Future<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(AboutInfo.self)
                .flatMap { _ -> Future<AboutInfo> in // save
                    return try req.content
                        .decode(AboutInfo.self)
                        .flatMap(to: AboutInfo.self) { $0.save(on: req) }
                }
                .transform(to: ServerResponse.defaultSuccess)
        }
        
        router.get("api", "about-info") { req -> Future<[AboutInfo]> in
            return AboutInfo.query(on: req).all()
        }
    }
}
