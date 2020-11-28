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
    func boot(routes: RoutesBuilder) throws {
        // MARK: - File Manipulation
        
        routes.get("api", "browse-files") { req -> EventLoopFuture<[FileToBrowse]> in
            try req.authenticate()
            let directoryType = try req.directoryType()
            let fm = FileManager.default
            let items = try fm
                .contentsOfDirectory(
                    at: directoryType.directory,
                    includingPropertiesForKeys: nil)
                .filterMultipleElements(
                    using: { !$0.absoluteString.contains($1) },
                    elements: [".gitkeep", ".gitignore"])
            return req.eventLoop.future(try items.map(FileToBrowse.init))
        }
        
        routes.post("api", "upload-file") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            let directoryType = try req.directoryType()
            return try saveWithOriginalFilename(on: req, directory: directoryType)
        }
        
        routes.post("api", "delete-files") { req -> EventLoopFuture<ServerResponse> in
            try req.authenticate()
            let directoryType = try req.directoryType()
            let file = try req.content.decode(FileToBrowse.self)
            try deleteFileNamed(file.name, at: directoryType)
            return req.eventLoop.future(ServerResponse.defaultSuccess)
        }
        
        routes.get("api", "directory-info") { req -> EventLoopFuture<DirectoryInfo> in
            try req.authenticate()
            let directoryType = try req.directoryType()
            let info = try DirectoryInfo(url: directoryType.directory)
            return req.eventLoop.future(info)
        }
        
        routes.get("api", "stream-file") { req -> EventLoopFuture<Response> in
            try req.authenticate()
            let directoryType = try req.directoryType()
            let name = try req.queryParam(named: "name", type: String.self)
            let file = req.fileio.streamFile(at: directoryType.directory.appendingPathComponent(name).relativePath)
            return req.eventLoop.future(file)
        }
    }
}

fileprivate extension Request {
    /// get the query parameter named `directory`
    func directoryType() throws -> Directory {
        guard let directory = query[String.self, at: "directory"],
              let directoryType = Directory(string: directory) else {
            throw NSError(domain: "Missing parameter directory", code: 0)
        }
        return directoryType
    }
}
