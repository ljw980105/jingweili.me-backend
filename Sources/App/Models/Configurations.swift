//
//  Configurations.swift
//  App
//
//  Created by Jing Wei Li on 7/26/20.
//

import Foundation
import Vapor

class Configurations: Codable {
    static let `default`: Configurations = .load()
    
    let unrestrictedCORS: Bool
    let mongoURL: String
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        unrestrictedCORS = try container.decode(Bool.self, forKey: .unrestrictedCORS)
        mongoURL = try container.decode(String.self, forKey: .mongoURL).base64Decoded()
    }
    
    private class func load() -> Configurations {
        do {
            let file = try readFileNamed("Configurations.json", directory: .root)
            return try JSONDecoder().decode(Configurations.self, from: file)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}


extension Configurations {
    func configureMiddlewaresFrom(app: Application) {
        if unrestrictedCORS {
            app.middleware.use(CORSMiddleware(configuration: CORSMiddleware.Configuration(
                allowedOrigin: .all,
                allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
                allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
            )))
        }
    }
}
