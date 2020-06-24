//
//  FileType.swift
//  App
//
//  Created by Jing Wei Li on 5/28/20.
//

import Foundation
import Vapor

enum FileType: String {
    case cv = "cv.pdf"
    case resume = "resume.pdf"
    
    func fileExists() -> Bool {
        let pwd = DirectoryConfig.detect().workDir
        return FileManager.default.fileExists(atPath: "\(pwd)Public/resources/\(rawValue)")
    }
}
