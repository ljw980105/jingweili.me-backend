//
//  PCSetupEntry.swift
//  App
//
//  Created by Jing Wei Li on 5/15/20.
//

import Foundation
import Vapor
import Fluent

final class PCSetupEntry: Codable, Model {
    @ID
    var id: UUID?
    @Field(key: "partName")
    var partName: String
    @Field(key: "partDetail")
    var partDetail: String
    @Field(key: "partPurchaseLink")
    var partPurchaseLink: String
}

extension PCSetupEntry: Content {}

extension PCSetupEntry: Migratable {
    static var idRequired: Bool {
        return true
    }
    
    static var fields: [FieldForMigratable] {
        return [
            .init("partName", .string),
            .init("partDetail", .string),
            .init("partPurchaseLink", .string),
        ]
    }
    
    static var schema: String {
        return "PCSetupEntry"
    }
}
