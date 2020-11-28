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
    func boot(routes: RoutesBuilder) throws {
        // MARK: - PC Entries
        routes.post("api", "pc-setup") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(PCSetupEntry.self)
                .flatMapThrowing { _ -> EventLoopFuture<Void> in
                    let setups =  try req.content.decode([PCSetupEntry].self)
                    return setups.save(on: req)
                }
                .transform(to: ServerResponse.defaultSuccess)
        }
        
        routes.get("api", "pc-setup") { req -> EventLoopFuture<[PCSetupEntry]> in
            return PCSetupEntry.query(on: req.db).all()
        }
        
        // MARK: - About
        routes.post("api", "about-info") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(AboutInfo.self)
                .flatMapThrowing { _ -> EventLoopFuture<Void> in // save
                    let aboutInfo = try req.content.decode(AboutInfo.self)
                    return aboutInfo.save(on: req.db)
                }
                .transform(to: ServerResponse.defaultSuccess)
        }
        
        routes.get("api", "about-info") { req -> EventLoopFuture<[AboutInfo]> in
            return AboutInfo.query(on: req.db).all()
        }
    }
}
