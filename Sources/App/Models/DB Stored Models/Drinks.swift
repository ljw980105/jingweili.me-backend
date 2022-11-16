//
//  Drinks.swift
//  
//
//  Created by Jing Wei Li on 11/13/22.
//

import Vapor
import Fluent

final class Drinks: Model, Content {
    @ID
    var id: UUID?
    @Field(key: "drinks")
    var drinks: [NameAndDescription]
}

extension Drinks: Migratable {
    
    static var schema: String {
        "Drinks"
    }
    
    static var fields: [FieldForMigratable] {
        [
            .init("drinks", .array)
        ]
    }
    
    static var idRequired: Bool {
        true
    }
}
