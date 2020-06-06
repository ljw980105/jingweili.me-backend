//
//  Global.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor

func readFileNamed(_ name: String, isPublic: Bool) throws -> Data {
    let pwd = DirectoryConfig.detect().workDir
    return try Data(contentsOf: URL(fileURLWithPath: pwd)
            .appendingPathComponent(isPublic ? "Public/" : "")
            .appendingPathComponent(name))
}

func readStringFromFile(named name: String, isPublic: Bool) throws -> String {
    let data = try readFileNamed(name, isPublic: isPublic)
    if let result = String(data: data, encoding: .utf8) {
        return result
    } else {
        throw NSError(domain: "Malformed string", code: 0)
    }
}

func deleteFileNamed(_ name: String, isPublic: Bool) throws {
    let pwd = DirectoryConfig.detect().workDir
    let url = URL(fileURLWithPath: pwd)
            .appendingPathComponent(isPublic ? "Public/" : "")
            .appendingPathComponent(name)
    try FileManager.default.removeItem(at: url)
}
