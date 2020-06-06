//
//  String+Extensions.swift
//  App
//
//  Created by Jing Wei Li on 6/5/20.
//

import Foundation
import Vapor

extension String {
    
    func base64Decoded() throws -> String {
        if let decodedData = Data(base64Encoded: self.trimmingCharacters(in: .newlines)),
            let decodedString = String(data: decodedData, encoding: .utf8) {
            return decodedString.trimmingCharacters(in: .newlines)
        } else {
            throw NSError(domain: "Unable to decode", code: 0)
        }
    }
    
    func saveToFileNamed(_ name: String, isPublic: Bool) throws {
        guard let url = URL(string: "file://" + DirectoryConfig.detect().workDir)?.appendingPathComponent("\(isPublic ? "Public/" : "")\(name)") else {
            throw NSError(domain: "Unable to get pwd", code: 0)
        }
        try self.write(to: url, atomically: true, encoding: .utf8)
    }
}
