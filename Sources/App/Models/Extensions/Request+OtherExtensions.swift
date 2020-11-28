//
//  Request+OtherExtensions.swift
//  App
//
//  Created by Jing Wei Li on 6/8/20.
//

import Foundation
import Vapor
import Fluent

typealias VaporRequestable = Model & Content

extension Request {
    
    /// Queries all the elements contained in DB of the provided type, then deletes them all
    /// - Parameter type: the type to delete
    /// - Parameter beforeDeleteCallback: called before delete. Must not throw. If there are expressions that throw, use `try?`
    /// - Returns: A EventLoopFuture indicating the completion of the request
    func deleteAllOnType<T: VaporRequestable>(
        _ type: T.Type,
        beforeDeleteCallback: @escaping ([T]) -> Void = { _ in }) -> EventLoopFuture<Void>
    {
        return T.query(on: db).all()
            .flatMap { results -> EventLoopFuture<Void> in // delete
                beforeDeleteCallback(results)
                return results.delete(on: self)
        }
    }
    
    func queryParam<T: Decodable>(named name: String, type: T.Type) throws -> T {
        guard let value = query[T.self, at: name] else {
            throw NSError(domain: "Missing query param \(name)", code: 0)
        }
        return value
    }
}
