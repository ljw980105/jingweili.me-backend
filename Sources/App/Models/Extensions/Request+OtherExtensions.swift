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
    /// - Returns: A Future indicating the completion of the request
    func deleteAllOnType<T: VaporRequestable>(_ type: T.Type) -> Future<Void> {
        return T.query(on: self).all()
            .flatMap { results -> Future<Void> in // delete
                return results.delete(on: self)
        }
    }
}
