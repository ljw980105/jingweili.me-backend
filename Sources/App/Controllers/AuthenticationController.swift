//
//  AuthenticationController.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor
import Fluent


/// - Authentication Workflow:
/// 1. User logs in by providing the password
/// 2. Server reads the password from a local file and compares it with the password from the request
/// 3. If the comparison succeeds, the server responds with a session id as token and saves it locally in a file `currentToken`
/// 4. Any restricted resources on the server must be accessed by providing the session token in the http header:
///```
/// Authorization: Bearer <session-id>
///```
/// 5. When the user logs out, the locally stored `currentToken` is deleted
/// * Note: This is not using JWTs because they do not support manual logout by invalidating a token
struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // MARK: - Login / Logout
        routes.post("api", "login") { req -> EventLoopFuture<Token> in
            let passwordObj = try req.content.decode(Password.self)
            let password = try readStringFromFile(named: "password", directory: .root).base64Decoded()
            guard password == passwordObj.password else {
                throw Abort(.unauthorized)
            }
            let token = String(randomWithLength: 20)
            try token.saveToFileNamed("currentToken", at: .root)
            return req.eventLoop.future(Token(token: token))
            
        }
        
        routes.get("api", "logout") { req -> EventLoopFuture<ServerResponse> in
            try deleteFileNamed("currentToken", at: .root)
            return req.eventLoop.future(ServerResponse.defaultSuccess)
        }
    }
}
