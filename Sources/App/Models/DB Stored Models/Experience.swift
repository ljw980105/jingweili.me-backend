//
//  Experience.swift
//  App
//
//  Created by Jing Wei Li on 6/20/20.
//

import Foundation
import Vapor
import FluentSQLite

final class Experience: Codable {
    var id: Int?
    let imageLink: String
    let position: String
    let time: String
    let company: String
    let accomplishments: [String]
    let special: String?
}

extension Experience: Model {
    typealias Database = SQLiteDatabase
    typealias ID = Int
    public static var idKey: IDKey = \Experience.id
}

extension Experience: Content, Migration, Parameter {
    
}
