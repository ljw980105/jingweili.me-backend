//
//  EventLoopFuture+Extensions.swift
//  App
//
//  Created by Jing Wei Li on 6/28/20.
//

import Foundation
import Vapor
import Fluent

extension EventLoopFuture {
    /// First decode the model object embeded in the request and then saves it in the DB
    func decodeAndSaveOnType<T: Model>(_ type: T.Type, req: Request) -> EventLoopFuture<ServerResponse> {
        return flatMapThrowing { _ -> EventLoopFuture<Void> in // save
            let result = try req.content.decode(T.self)
            return result.save(on: req.db)
        }
        .transform(to: req.eventLoop.future(ServerResponse.defaultSuccess))
    }
    
    /// First decode the model object embeded in the request and then saves it in the DB
    /// - Parameters:
    ///   - type: The type of the array's inner element
    ///   - req: The vapor request
    /// - Returns: A EventLoopFuture indicating completion
    func decodeAndSaveOnArrayTyped<T: Model>(_ type: T.Type, req: Request) -> EventLoopFuture<ServerResponse> {
        return flatMapThrowing { _ -> EventLoopFuture<Void> in // save
            let array = try req.content.decode([T].self)
            return array.save(on: req)
        }
        .transform(to: req.eventLoop.future(ServerResponse.defaultSuccess))
    }
}
