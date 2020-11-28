//
//  ResumeData.swift
//  App
//
//  Created by Jing Wei Li on 6/24/20.
//

import Foundation
import Vapor
import Fluent

final class ResumeData: Codable, Content, Model {
    @ID
    var id: UUID?
    @Field(key: "appsWorkedOn")
    var appsWorkedOn: Int
    @Field(key: "commercialAppsWorkedOn")
    var commercialAppsWorkedOn: Int
    @Field(key: "appsPublished")
    var appsPublished: Int
    @Field(key: "iosSkills")
    var iosSkills: [GenericFeature]
    @Field(key: "webSkillsFrontend")
    var webSkillsFrontend: [TextAndImage]
    @Field(key: "webSkillsBackend")
    var webSkillsBackend: [TextAndImage]
    @Field(key: "webSkillsGeneral")
    var webSkillsGeneral: [TextAndImage]
    @Field(key: "graphicSkills")
    var graphicSkills: [GenericFeature]
}

final class GenericFeature: Content {
    let name: String
    let details: [String]
}

final class TextAndImage: Content {
    let imageUrl: String
    let text: String
}

extension ResumeData: Migratable {
    static var idRequired: Bool {
        return true
    }
    
    static var schema: String {
        return "ResumeData"
    }
    
    static var fields: [FieldForMigratable] {
        return [
            .init("appsWorkedOn", .int),
            .init("commercialAppsWorkedOn", .int),
            .init("appsPublished", .int),
            .init("iosSkills", .array(of: .dictionary)),
            .init("webSkillsFrontend", .array(of: .dictionary)),
            .init("webSkillsBackend", .array(of: .dictionary)),
            .init("webSkillsGeneral", .array(of: .dictionary)),
            .init("graphicSkills", .array(of: .dictionary)),
        ]
    }
}
