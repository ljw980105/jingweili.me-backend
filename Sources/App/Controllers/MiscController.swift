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
            let directoryType = try req.directoryType()
            let fm = FileManager.default
            let items = try fm.contentsOfDirectory(
                at: directoryType.directory,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles)
            return req.future(try items.map(FileToBrowse.init))
        }
        
        router.post("api", "upload-file") { req -> Future<ServerResponse> in
            try req.authenticate()
            let directoryType = try req.directoryType()
            return try saveWithOriginalFilename(on: req, directory: directoryType)
        }
        
        router.post("api", "delete-files") { req -> Future<ServerResponse> in
            try req.authenticate()
            let directoryType = try req.directoryType()
            return try req.content
                .decode(FileToBrowse.self)
                .flatMap { file -> Future<ServerResponse> in
                    try deleteFileNamed(file.name, at: directoryType)
                    return req.future(ServerResponse.defaultSuccess)
                }
        }
        
        router.get("api", "stream-file") { req -> Future<Response> in
            try req.authenticate()
            let directoryType = try req.directoryType()
            let name = try req.queryParam(named: "name", type: String.self)
            return try req.streamFile(at: directoryType.directory.appendingPathComponent(name).relativePath)
        }
    }
}

fileprivate extension Request {
    /// get the query parameter named `directory`
    func directoryType() throws -> DirectoryType {
        guard let directory = query[String.self, at: "directory"],
              let directoryType = DirectoryType(string: directory) else {
            throw NSError(domain: "Missing parameter directory", code: 0)
        }
        return directoryType
    }
}
