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
        let url = URL(fileURLWithPath: DirectoryConfig.detect().workDir)
            .appendingPathComponent("\(isPublic ? "Public/" : "")\(name)")
        try self.write(to: url, atomically: true, encoding: .utf8)
    }

    init(randomWithLength length: Int) {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        self = String((0..<length).compactMap { _ in letters.randomElement() })
    }
}
