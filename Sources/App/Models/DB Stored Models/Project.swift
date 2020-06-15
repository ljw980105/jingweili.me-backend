//
//  Project.swift
//  App
//
//  Created by Jing Wei Li on 6/15/20.
//

import Foundation
import Vapor
import FluentSQLite

final class Project: Codable {
    var id: Int?
    let imageUrl: String
    let name: String
    let description: String
    let links: [ProjectLink]
    let technologies: [String]
}

final class ProjectLink: Content {
    let name: String
    let url: URL
}

extension Project: Model {
    typealias Database = SQLiteDatabase
    typealias ID = Int
    public static var idKey: IDKey = \Project.id
}

extension Project: Content, Migration, Parameter {
    
}

