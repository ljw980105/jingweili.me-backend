//
//  Global.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor

// MARK: - File Operations

func readFileNamed(_ name: String, directory: Directory) throws -> Data {
    return try Data(contentsOf: directory.directory
            .appendingPathComponent(name))
}

func readStringFromFile(named name: String, directory: Directory) throws -> String {
    let data = try readFileNamed(name, directory: directory)
    if let result = String(data: data, encoding: .utf8) {
        return result
    } else {
        throw NSError(domain: "Malformed string", code: 0)
    }
}

func deleteFileNamed(_ name: String, at directory: Directory) throws {
    print("File \(name) deleted at directory \(directory.rawValue)")
    let url = directory.directory.appendingPathComponent(name)
    try FileManager.default.removeItem(at: url)
}

// MARK: - PWD

/// Wrapper for the vapor's current working directory
class PWDWrapper {
    fileprivate static var pwd: String = ""
    
    static func setPWD(with app: Application) {
        self.pwd = app.directory.workingDirectory
    }
}

/// Vapor's current working directory, available to have files written to it.
func pwd() -> URL {
    return URL(fileURLWithPath: PWDWrapper.pwd)
}
