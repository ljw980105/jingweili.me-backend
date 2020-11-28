//
//  GraphicProject.swift
//  App
//
//  Created by Jing Wei Li on 6/2/20.
//

import Foundation
import Vapor
import Fluent

final class GraphicProject: Codable, Model, Content {
    @ID
    var id: UUID?
    @Field(key: "name")
    var name: String
    @Field(key: "description")
    var description: String
    @Field(key: "imageURLRectangle")
    var imageURLRectangle: String
    @Field(key: "imageURLSquare")
    var imageURLSquare: String
    @Field(key: "projectURL")
    var projectURL: String
}

extension GraphicProject: Migratable {
    static var schema: String {
        return "GraphicProject"
    }
    
    static var fields: [FieldForMigratable] {
        return [
            .init("name", .string),
            .init("description", .string),
            .init("imageURLRectangle", .string),
            .init("imageURLSquare", .string),
            .init("projectURL", .string),
        ]
    }
    
    static var idRequired: Bool {
        return true
    }
}


