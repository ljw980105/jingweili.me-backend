//
//  Project.swift
//  App
//
//  Created by Jing Wei Li on 6/15/20.
//

import Foundation
import Vapor
import Fluent

final class Project: Codable, Content, Model {
    @ID
    var id: UUID?
    @Field(key: "imageUrl")
    var imageUrl: String
    @Field(key: "name")
    var name: String
    @Field(key: "description")
    var description: String
    @Field(key: "links")
    var links: [ProjectLink]
    @Field(key: "technologies")
    var technologies: [String]
}

final class ProjectLink: Content {
    let name: String
    let url: URL
}

extension Project: Migratable {
    static var schema: String {
        return "Project"
    }
    
    static var fields: [FieldForMigratable] {
        return [
            .init("imageUrl", .string),
            .init("name", .string),
            .init("description", .string),
            .init("links", .array(of: .dictionary)),
            .init("technologies", .array(of: .string))
        ]
    }
    
    static var idRequired: Bool {
        return true
    }
}

