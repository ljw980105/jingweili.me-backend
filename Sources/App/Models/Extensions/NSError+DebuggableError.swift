//
//  NSError+DebuggableError.swift
//  App
//
//  Created by Jing Wei Li on 6/24/20.
//

import Foundation
import Vapor

extension NSError: DebuggableError {
    public var identifier: String {
        return String(code)
    }
    
    public var reason: String {
        return localizedDescription
    }

}
