//
//  FeatureFlags.swift
//  App
//
//  Created by Jing Wei Li on 7/26/20.
//

import Foundation
import Vapor

class FeatureFlags: Codable {
    static let `default`: FeatureFlags = .load()
    
    let unrestrictedCORS: Bool
    
    private class func load() -> FeatureFlags {
        do {
            let file = try readFileNamed("FeatureFlags.json", isPublic: false)
            return try JSONDecoder().decode(FeatureFlags.self, from: file)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}


extension FeatureFlags {
    func configureMiddlewareFrom(config: inout MiddlewareConfig) {
        if unrestrictedCORS {
            config.use(CORSMiddleware(configuration: CORSMiddleware.Configuration(
                allowedOrigin: .all,
                allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
                allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
            )))
        }
    }
}
