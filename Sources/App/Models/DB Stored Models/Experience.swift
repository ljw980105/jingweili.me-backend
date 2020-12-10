//
//  Experience.swift
//  App
//
//  Created by Jing Wei Li on 6/20/20.
//

import Foundation
import Vapor
import Fluent

final class Experience: Codable, Model, Content {
    @ID
    var id: UUID?
    @Field(key: "imageLink")
    var imageLink: String
    @Field(key: "position")
    var position: String
    @Field(key: "time")
    var time: String
    @Field(key: "company")
    var company: String
    @Field(key: "accomplishments")
    var accomplishments: [String]
    @Field(key: "special")
    var special: String?
    @Field(key: "order")
    var order: Int
}

extension Experience: Migratable {
    static var schema: String {
        return "Experience"
    }
    
    static var fields: [FieldForMigratable] {
        return [
            .init("imageLink", .string),
            .init("position", .string),
            .init("time", .string),
            .init("company", .string),
            .init("accomplishments", .array(of: .string)),
            .init("special", .string, false),
            .init("order", .int)
        ]
    }
    
    static var idRequired: Bool {
        return true
    }
}
