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
        guard let bearer = self.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        let currentToken = try readStringFromFile(named: "currentToken", isPublic: false)
        guard currentToken == bearer.token else {
            throw Abort(.unauthorized)
        }
    }
}
