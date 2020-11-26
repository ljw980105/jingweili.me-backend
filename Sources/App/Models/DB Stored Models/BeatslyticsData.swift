//
//  BeatslyticsData.swift
//  App
//
//  Created by Jing Wei Li on 6/28/20.
//

import Foundation
import Vapor
import Fluent

final class BeatslyticsData: Codable, Model {
    @ID
    var id: UUID?
    @Field(key: "metaAppStoreName")
    var metaAppStoreName: String
    @Field(key: "metaAppStoreContent")
    var metaAppStoreContent: String
    @Field(key: "headline")
    var headline: String
    @Field(key: "intro")
    var intro: String
    @Field(key: "appStore")
    var appStore: String
    @Field(key: "features")
    var features: [GenericFeature]
    @Field(key: "support")
    var support: String
    @Field(key: "license_agreement_url")
    var license_agreement_url: String
    @Field(key: "privacy_policy_url")
    var privacy_policy_url: String
    @Field(key: "credits")
    var credits: GenericFeature
}

extension BeatslyticsData: Content  {
    
}

extension BeatslyticsData: Migratable {
    static var idRequired: Bool {
        return true
    }
    
    static var fields: [FieldForMigratable] {
        return [
            .init("metaAppStoreName", .string),
            .init("metaAppStoreContent", .string),
            .init("headline", .string),
            .init("intro", .string),
            .init("appStore", .string),
            .init("features", .array(of: .dictionary(of: .dictionary))),
            .init("support", .string),
            .init("license_agreement_url", .string),
            .init("privacy_policy_url", .string),
            .init("credits", .dictionary),
        ]
    }
    
    static var schema: String {
        return "BeatslyticsData"
    }
}
