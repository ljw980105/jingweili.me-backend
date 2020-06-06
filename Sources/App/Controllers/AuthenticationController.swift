//
//  AuthenticationController.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor
import Fluent
import JWT


/// - Authentication Workflow:
/// 1. User logs in in by providing the password
/// 2. Server reads the password from a local file and compares it with the password from the request
/// 3. If the comparison succeeds, the server responds with a jwt token and saves it locally in a file `currentToken`
/// 4. Any restricted resources on the server must be accessed by providing the jwt token in the http header:
///```
/// Authorization: Bearer <jwt-token>
///```
/// 5. When the user logs out, the locally stored `currentToken` is deleted
struct AuthenticationController: RouteCollection {
    func boot(router: Router) throws {
        // MARK: - Login / Logout
        router.post("api", "login") { req -> Future<Token> in
            return try req.content
                .decode(Password.self)
                .flatMap { passwordObj -> Future<Token> in
                    let password = try readStringFromFile(named: "password", isPublic: false).base64Decoded()
                    guard password == passwordObj.password else {
                        throw Abort(.unauthorized)
                    }
                    let key = try readStringFromFile(named: "jwtKey.key", isPublic: false)
                    let jwt = try JWT(payload: JWTToken()).sign(using: .hs256(key: key))
                    guard let string = String(data: jwt, encoding: .utf8) else {
                        throw NSError(domain: "Unknown", code: 0)
                    }
                    try string.saveToFileNamed("currentToken", isPublic: false)
                    return req.future(Token(token: string))
                }
        }
        
        router.get("api", "logout") { req -> Future<ServerResponse> in
            try deleteFileNamed("currentToken", isPublic: false)
            return req.future(ServerResponse.defaultSuccess)
        }
    }
}
