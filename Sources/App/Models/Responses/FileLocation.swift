//
//  FileLocation.swift
//  App
//
//  Created by Jing Wei Li on 5/28/20.
//

import Foundation
import Vapor

struct FileLocation: Content {
    let exists: Bool
    let url: String
}
