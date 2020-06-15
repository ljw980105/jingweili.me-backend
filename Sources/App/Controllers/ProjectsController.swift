//
//  ProjectsController.swift
//  App
//
//  Created by Jing Wei Li on 6/15/20.
//

import Foundation
import Vapor
import Fluent

struct ProjectsController: RouteCollection {
    func boot(router: Router) throws {
        
        router.post("api", "projects") { req -> Future<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(Project.self, beforeDeleteCallback: { projects in
                    projects.forEach { try? deleteFileNamed($0.imageUrl, isPublic: true) }
                })
                .flatMap { _ -> Future<[Project]> in // save
                    return try req.content
                        .decode([Project].self)
                        .flatMap { $0.save(on: req) }
                }
                .transform(to: req.future(ServerResponse.defaultSuccess))
        }
        
        router.get("api", "projects") { req -> Future<[Project]> in
            return Project.query(on: req).all()
        }
    }
}
