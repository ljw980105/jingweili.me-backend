//
//  Request+OtherExtensions.swift
//  App
//
//  Created by Jing Wei Li on 6/8/20.
//

import Foundation
import Vapor
import FluentSQLite

typealias VaporRequestable = Model & Content & Migration & Parameter

extension Request {
    
    /// Queries all the elements contained in DB of the provided type, then deletes them all
    /// - Parameter type: the type to delete
    /// - Parameter beforeDeleteCallback: called before delete. Must not throw. If there are expressions that throw, use `try?`
    /// - Returns: A Future indicating the completion of the request
    func deleteAllOnType<T: VaporRequestable>(
        _ type: T.Type,
        beforeDeleteCallback: @escaping ([T]) -> Void = { _ in }) -> Future<Void>
    {
        return T.query(on: self).all()
            .flatMap { results -> Future<Void> in // delete
                beforeDeleteCallback(results)
                return results.delete(on: self)
        }
    }
}
