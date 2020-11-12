//
//  MiscController.swift
//  App
//
//  Created by Jing Wei Li on 11/5/20.
//

import Foundation
import Vapor
import Fluent

struct MiscController: RouteCollection {
    func boot(router: Router) throws {
        // MARK: - File Manipulation
        
        router.get("api", "browse-files") { req -> Future<[FileToBrowse]> in
            try req.authenticate()
            guard let directory = req.query[String.self, at: "directory"],
                  let directoryType = DirectoryType(string: directory) else {
                throw NSError(domain: "Missing parameter directory", code: 0)
            }
            let fm = FileManager.default
            let items = try fm.contentsOfDirectory(
                at: directoryType.directory,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles)
            return req.future(try items.map(FileToBrowse.init))
        }
        
        router.post("api", "upload-file") { req -> Future<ServerResponse> in
            try req.authenticate()
            return try saveWithOriginalFilename(on: req)
        }
        
        router.post("api", "delete-files") { req -> Future<ServerResponse> in
            try req.authenticate()
            guard let directory = req.query[String.self, at: "directory"],
                  let directoryType = DirectoryType(string: directory) else {
                throw NSError(domain: "Missing parameter directory", code: 0)
            }
            return try req.content
                .decode(FileToBrowse.self)
                .flatMap { file -> Future<ServerResponse> in
                    try deleteFileNamed(file.name, at: directoryType)
                    return req.future(ServerResponse.defaultSuccess)
                }
            
        }
    }
}
