//
//  Array+FluentSave.swift
//  App
//
//  Created by Jing Wei Li on 5/15/20.
//

import Foundation
import Vapor
import FluentSQLite

extension Array where Element: Model {
    /// Saves an array of elements to the database.
    func save(on request: Request) -> Future<[Element]> {
        return self
            .map { $0.create(on: request) }
            .flatten(on: request)
    }
    
    func delete(on request: Request) -> Future<Void> {
        return self
            .map { $0.delete(on: request) }
            .flatten(on: request)
    }
}
