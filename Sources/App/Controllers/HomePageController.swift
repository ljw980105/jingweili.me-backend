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
        router.post("api", "add_pc_entry") { req -> Future<ServerResponse> in
           return try req.content
            .decode([PCSetupEntry].self)
            .flatMap(to: [PCSetupEntry].self) { (setups: [PCSetupEntry]) -> Future<[PCSetupEntry]> in
                return setups.save(on: req)
            }
           .transform(to: ServerResponse.defaultSuccess)
        }
        
        router.get("api", "get_pc_entries") { req -> Future<[PCSetupEntry]> in
            return PCSetupEntry.query(on: req).all()
        }
        
        // MARK: - File Upload
        router.post("api", "upload-file") { req -> Future<ServerResponse> in
            try req.authenticate()
            return try saveWithOriginalFilename(on: req)
        }
    }
}
