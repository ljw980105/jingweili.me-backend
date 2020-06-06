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
