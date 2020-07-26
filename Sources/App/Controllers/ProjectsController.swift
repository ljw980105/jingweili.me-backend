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
            return req.deleteAllOnType(Project.self)
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
        
        router.get("api", "projects", "simplified") { req -> Future<[NameAndURL]> in
            return Project.query(on: req).all()
                .map { projects -> [Project] in
                    if let limit = req.query[Int.self, at: "limit"] {
                         if limit == 0 { throw NSError(domain: "Limit cannot be 0" , code: 0) }
                         return projects.count > limit ? Array(projects.prefix(limit)) : projects
                    }
                    return projects
                }
                .map { projects -> [NameAndURL] in
                    return projects.compactMap { NameAndURL(project: $0) }
                }
        }
    }
}
