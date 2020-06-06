//
//  JWTToken.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor
import JWT

struct JWTToken: JWTPayload {
    let created: Date
    
    func verify(using signer: JWTSigner) throws {
        
    }
    
    init() {
        created = Date()
    }
}

struct Token: Content {
    let token: String
}
