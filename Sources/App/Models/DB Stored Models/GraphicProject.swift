//
//  GraphicProject.swift
//  App
//
//  Created by Jing Wei Li on 6/2/20.
//

import Foundation
import Vapor
import FluentSQLite

final class GraphicProject: Codable {
    var id: Int?
    let name: String
    let description: String
    let imageURLRectangle: String
    let imageURLSquare: String
    let projectURL: String
}

extension GraphicProject: Model {
    typealias Database = SQLiteDatabase
    typealias ID = Int
    public static var idKey: IDKey = \GraphicProject.id
}

extension GraphicProject: Content {}

extension GraphicProject: Migration {}

extension GraphicProject: Parameter {}

