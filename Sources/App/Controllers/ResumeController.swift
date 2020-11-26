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
    func boot(routes: RoutesBuilder) throws {
        // MARK: - Resumes and CVs
        routes.post("api", "upload-resume") { (req: Request) -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return try req.saveFileTyped(.resume)
        }
        
        routes.post("api", "upload-cv") { (req: Request) -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return try req.saveFileTyped(.cv)
        }
        
        routes.get("api", "cv") { req -> EventLoopFuture<FileLocation> in
            let exists = FileType.cv.fileExists()
            return req.eventLoop.future(FileLocation(exists: exists, url: exists ? FileType.cv.rawValue : ""))
        }
        
        routes.get("api", "resume") { req -> EventLoopFuture<FileLocation> in
            let exists = FileType.resume.fileExists()
            return req.eventLoop.future(FileLocation(exists: exists, url: exists ? FileType.resume.rawValue : ""))
        }
        
        // MARK: - Experiences
        routes.get("api", "experiences") { req -> EventLoopFuture<[Experience]> in
            return Experience.query(on: req.db).all()
        }
        
        routes.post("api", "experiences") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(Experience.self)
                .flatMapThrowing { _ -> EventLoopFuture<Void> in
                    let experiences = try req.content.decode([Experience].self)
                    return experiences.save(on: req)
                }
                .transform(to: ServerResponse.defaultSuccess)
        }
        
        // MARK: - Resume Data
        routes.get("api", "resume-data") { req -> EventLoopFuture<ResumeData> in
            return ResumeData
                .query(on: req.db)
                .first()
                .unwrap(orError: NSError(domain: "No Resume Data Exists", code: 0))
        }
        
        routes.post("api", "resume-data") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(ResumeData.self, beforeDeleteCallback: { data in
                    data.forEach { data in
                        let webskills = data.webSkillsFrontend + data.webSkillsBackend + data.webSkillsGeneral
                        webskills.forEach { try? deleteFileNamed($0.imageUrl, at: .public) }
                    }
                })
                .flatMapThrowing { _ -> EventLoopFuture<Void> in
                    let resumeData = try req.content.decode(ResumeData.self)
                    return resumeData.save(on: req.db)
                }
                .transform(to: ServerResponse.defaultSuccess)
        }
    }
}
