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
    func boot(routes: RoutesBuilder) throws {
        
        routes.post("api", "projects") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(Project.self)
                .flatMapThrowing { _ -> EventLoopFuture<Void> in // save
                    let projects = try req.content.decode([Project].self)
                    return projects.save(on: req)
                }
                .transform(to: req.eventLoop.future(ServerResponse.defaultSuccess))
        }
        
        routes.get("api", "projects") { req -> EventLoopFuture<[Project]> in
            return Project.query(on: req.db).all()
        }
        
        routes.get("api", "projects", "simplified") { req -> EventLoopFuture<[NameAndURL]> in
            return Project.query(on: req.db).all()
                .flatMapThrowing { projects -> [Project] in
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
