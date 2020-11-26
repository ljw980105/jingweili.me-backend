//
//  GraphicsController.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor
import Fluent

struct GraphicsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("api", "get-graphic-projects") { req -> EventLoopFuture<[GraphicProject]> in
            return GraphicProject.query(on: req.db).all()
        }
        
        routes.get("api", "get-graphic-projects/simplified") { req -> EventLoopFuture<[NameAndURL]> in
            return GraphicProject.query(on: req.db).all()
                .flatMapThrowing { projects -> [GraphicProject] in
                    if let limit = req.query[Int.self, at: "limit"] {
                        if limit == 0 { throw NSError(domain: "Limit cannot be 0" , code: 0) }
                         return projects.count > limit ? Array(projects.prefix(limit)) : projects
                    }
                    return projects
                }
                .map { projects -> [NameAndURL] in
                    return projects.compactMap { NameAndURL(graphic: $0) }
                }
        }
        
        routes.post("api", "add-graphic-project") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            let graphicProject = try req.content.decode(GraphicProject.self)
            return graphicProject
                .save(on: req.db)
                .transform(to: ServerResponse.defaultSuccess)
        }
        
        routes.delete("api", "delete-graphic-project") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            guard let id = req.parameters.get("id") as? UUID else {
                throw Abort(.internalServerError)
            }
            return GraphicProject.find(id, on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { project in
                    project
                        .delete(on: req.db)
                        .transform(to: ServerResponse.defaultSuccess)
                }
        }
        
        routes.post("api", "multiple-graphics-projects") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return req
                .deleteAllOnType(GraphicProject.self)
                .decodeAndSaveOnArrayTyped(GraphicProject.self, req: req)
        }
    }
}
