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
        // MARK: - Resumes and CVs
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
        
        // MARK: - Experiences
        router.get("api", "experiences") { req -> Future<[Experience]> in
            return Experience.query(on: req).all()
        }
        
        router.post("api", "experiences") { req -> Future<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(Experience.self)
                .flatMap { _ -> Future<[Experience]> in
                    return try req.content
                        .decode([Experience].self)
                        .flatMap(to: [Experience].self) { $0.save(on: req) }
                }
                .transform(to: ServerResponse.defaultSuccess)
        }
        
        // MARK: - Resume Data
        router.get("api", "resume-data") { req -> Future<ResumeData> in
            return ResumeData.query(on: req).all()
                .map { multipleData -> ResumeData in
                    guard let first = multipleData.first else {
                        throw NSError(domain: "No Resume Data Exists", code: 0, userInfo: nil)
                    }
                    return first
            }
        }
        
        router.post("api", "resume-data") { req -> Future<ServerResponse> in
            try req.authenticate()
            return req.deleteAllOnType(ResumeData.self, beforeDeleteCallback: { data in
                    data.forEach { data in
                        let webskills = data.webSkillsFrontend + data.webSkillsBackend + data.webSkillsGeneral
                        webskills.forEach { try? deleteFileNamed($0.imageUrl, isPublic: true) }
                    }
                })
                .flatMap { _ -> Future<ResumeData> in
                    return try req.content
                        .decode(ResumeData.self)
                        .flatMap(to: ResumeData.self) { $0.save(on: req) }
                }
                .transform(to: ServerResponse.defaultSuccess)
        }
    }
}
