//
//  ResumeData.swift
//  App
//
//  Created by Jing Wei Li on 6/24/20.
//

import Foundation
import Vapor
import FluentSQLite

final class ResumeData: Codable {
    var id: Int?
    let appsWorkedOn: Int
    let commercialAppsWorkedOn: Int
    let appsPublished: Int
    let iosSkills: [GenericFeature]
    let webSkillsFrontend: [TextAndImage];
    let webSkillsBackend: [TextAndImage];
    let webSkillsGeneral: [TextAndImage];
    let graphicSkills: [GenericFeature];
}

final class GenericFeature: Content {
    let name: String
    let details: [String]
}

final class TextAndImage: Content {
    let imageUrl: String
    let text: String
}

extension ResumeData: Model {
    typealias Database = SQLiteDatabase
    typealias ID = Int
    public static var idKey: IDKey = \ResumeData.id
}

extension ResumeData: Content, Migration, Parameter {
    
}

