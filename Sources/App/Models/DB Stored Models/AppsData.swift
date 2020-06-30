//
//  AppsData.swift
//  App
//
//  Created by Jing Wei Li on 6/26/20.
//

import Foundation
import Vapor
import FluentSQLite

final class AppsData: Codable {
    var id: Int?
    let apps: [AppsOrSkill]
    let skills: [AppsOrSkill]
}

final class AppsOrSkill: Content {
    let imageLink: String
    let name: String
    let description: String
    let description2: String?
    let linkTitle: String?
    let link: String?
}

extension AppsData: Model {
    typealias Database = SQLiteDatabase
    typealias ID = Int
    public static var idKey: IDKey = \AppsData.id
}

extension AppsData: Content, Migration, Parameter {
    
}

