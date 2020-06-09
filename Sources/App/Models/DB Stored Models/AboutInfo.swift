//
//  AboutInfo.swift
//  App
//
//  Created by Jing Wei Li on 6/8/20.
//

import Foundation
import Vapor
import FluentSQLite

final class AboutInfo: Codable {
    var id: Int?
    let content: String
    let imageUrl: String
}

extension AboutInfo: Model {
    typealias Database = SQLiteDatabase
    typealias ID = Int
    public static var idKey: IDKey = \AboutInfo.id
}

extension AboutInfo: Content, Migration, Parameter {
    
}
