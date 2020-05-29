//
//  UploadedFile.swift
//  App
//
//  Created by Jing Wei Li on 5/28/20.
//

import Foundation
import Vapor

struct UploadedFile: Content {
    let file: Data
}
