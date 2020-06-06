//
//  ResumeController.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor
import Fluent

struct ResumeController: RouteCollection {
    func boot(router: Router) throws {
        router.post("api", "upload-resume") { (req: Request) -> Future<ServerResponse> in
            try req.authenticate()
            return try req.saveFileTyped(.resume)
        }
        
        router.post("api", "upload-cv") { (req: Request) -> Future<ServerResponse> in
            try req.authenticate()
            return try req.saveFileTyped(.cv)
        }
        
        router.get("api", "cv") { req -> Future<FileLocation> in
            let exists = FileType.cv.fileExists()
            return req.future(FileLocation(exists: exists, url: exists ? FileType.cv.rawValue : ""))
        }
        
        router.get("api", "resume") { req -> Future<FileLocation> in
            let exists = FileType.resume.fileExists()
            return req.future(FileLocation(exists: exists, url: exists ? FileType.resume.rawValue : ""))
        }
    }
}
