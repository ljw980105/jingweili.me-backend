//
//  Request+Auth.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor

extension Request {
    func authenticate() throws {
        guard let bearerToken = headers.first(name: "Authorization") else {
            throw Abort(.unauthorized)
        }
        let currentToken = try readStringFromFile(named: "currentToken", directory: .root)
        guard currentToken == bearerToken.replacingOccurrences(of: "Bearer ", with: "") else {
            throw Abort(.unauthorized)
        }
    }
}
