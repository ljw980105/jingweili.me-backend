//
//  AboutInfo.swift
//  App
//
//  Created by Jing Wei Li on 6/8/20.
//

import Foundation
import Vapor
import Fluent

final class AboutInfo: Codable, Model {
    @ID
    var id: UUID?
    @Field(key: "content")
    var content: String
    @Field(key: "imageUrl")
    var imageUrl: String
}

extension AboutInfo: Content {
    
}

extension AboutInfo: Migratable {
    static var idRequired: Bool {
        return true
    }
    
    static var schema: String {
        return "AboutInfo"
    }
    
    static var fields: [FieldForMigratable] {
        return [
            .init("content", .string),
            .init("imageUrl", .string)
        ]
    }
}
