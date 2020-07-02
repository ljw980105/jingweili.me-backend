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
    func boot(router: Router) throws {
        router.get("api", "get-graphic-projects") { req -> Future<[GraphicProject]> in
            return GraphicProject.query(on: req).all()
        }
        
        router.get("api", "get-graphic-projects/simplified") { req -> Future<[NameAndURL]> in
            return GraphicProject.query(on: req).all()
                .map { projects -> [GraphicProject] in
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
        
        router.post("api", "add-graphic-project") { req -> Future<ServerResponse> in
            try req.authenticate()
            return try req.content
                .decode(GraphicProject.self)
                .flatMap(to: GraphicProject.self) { $0.save(on: req) }
                .transform(to: ServerResponse.defaultSuccess)
        }
        
        router.delete("api", "delete-graphic-project", GraphicProject.parameter) { req -> Future<ServerResponse> in
            try req.authenticate()
            return try req.parameters.next(GraphicProject.self)
                .delete(on: req)
                .transform(to: ServerResponse.defaultSuccess)
        }
    }
}
