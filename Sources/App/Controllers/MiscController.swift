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
        router.get("api", "browse-files") { req -> Future<[FileToBrowse]> in
            try req.authenticate()
            let fm = FileManager.default
            let items = try fm.contentsOfDirectory(
                at: directoryAtPublic(),
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles)
            return req.future(try items.map(FileToBrowse.init))
        }
    }
}
