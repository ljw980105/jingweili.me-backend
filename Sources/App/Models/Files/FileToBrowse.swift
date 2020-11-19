//
//  FileToBrowse.swift
//  App
//
//  Created by Jing Wei Li on 11/6/20.
//

import Foundation
import Vapor

private let resourceKeys: [URLResourceKey] = [.creationDateKey, .fileSizeKey]

struct FileToBrowse: Content {
    let name: String
    let type: String
    let createdDate: Date?
    let fileSize: Int64?
    
    init(url: URL) throws {
        name = url.lastPathComponent
        type = url.pathExtension
        #if os(macOS)
        let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys)).allValues
        createdDate = resourceValues[.creationDateKey] as? Date
        fileSize = (resourceValues[.fileSizeKey] as? NSNumber)?.int64Value
        #else
        createdDate = Date(timeIntervalSinceReferenceDate: 0)
        fileSize = 0
        #endif
    }
}
