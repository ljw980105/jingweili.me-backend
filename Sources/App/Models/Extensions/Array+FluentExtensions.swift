//
//  Array+FluentSave.swift
//  App
//
//  Created by Jing Wei Li on 5/15/20.
//

import Foundation
import Vapor
import Fluent

extension Array where Element: Model {
    /// Saves an array of elements to the database.
    func save(on request: Request) -> EventLoopFuture<Void> {
        return request.eventLoop.flatten(map { $0.create(on: request.db) })
    }
    
    func delete(on request: Request) -> EventLoopFuture<Void> {
        return request.eventLoop.flatten(map { $0.delete(on: request.db) })
    }
}
