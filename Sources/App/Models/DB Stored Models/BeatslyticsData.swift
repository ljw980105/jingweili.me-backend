//
//  BeatslyticsData.swift
//  App
//
//  Created by Jing Wei Li on 6/28/20.
//

import Foundation
import Vapor
import FluentSQLite

final class BeatslyticsData: Codable {
    var id: Int?
    let metaAppStoreName: String
    let metaAppStoreContent: String
    let headline: String
    let intro: String
    let appStore: String
    let features: [GenericFeature]
    let support: String;
    let license_agreement_url: String
    let privacy_policy_url: String
    let credits: GenericFeature
}

extension BeatslyticsData: Model {
    typealias Database = SQLiteDatabase
    typealias ID = Int
    public static var idKey: IDKey = \BeatslyticsData.id
}

extension BeatslyticsData: Content, Migration, Parameter {
    
}
