//
//  AppsData.swift
//  App
//
//  Created by Jing Wei Li on 6/26/20.
//

import Foundation
import Vapor
import Fluent

final class AppsData: Codable, Model {
    @ID
    var id: UUID?
    @Field(key: "apps")
    var apps: [AppsOrSkill]
    @Field(key: "skills")
    var skills: [AppsOrSkill]
}

final class AppsOrSkill: Content {
    let imageLink: String
    let name: String
    let description: String
    let description2: String?
    let linkTitle: String?
    let link: String?
}

extension AppsData: Content {
    
}

extension AppsData: Migratable {
    static var idRequired: Bool {
        return true
    }
    
    static var fields: [FieldForMigratable] {
        return [
            .init("apps", .array(of: .dictionary)),
            .init("skills", .array(of: .dictionary))
        ]
    }
    
    static var schema: String {
        return "AppsData"
    }
}

