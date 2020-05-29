//
//  Request+SaveFile.swift
//  App
//
//  Created by Jing Wei Li on 5/28/20.
//

import Foundation
import Vapor

extension Request {
    func saveFileTyped(_ type: FileType) throws -> Future<ServerResponse> {
        return try saveToUrlComponent("Public/\(type.rawValue)", on: self)
    }
}

/// Saves the file contained in the request to the url component specified.
/// - Default behavior will allow the file saved to be overwritten if it's already there.
/// - If the file is uploaded through web, use `formData`, and make sure it has a field named `file`, like this:
/// ```
/// formData.append('file', fileToUpload);
/// ```
func saveToUrlComponent(_ urlComponent: String, on req: Request) throws -> Future<ServerResponse> {
    return try req
        .content
        .decode(UploadedFile.self)
        .flatMap { file -> Future<ServerResponse> in
            guard let url = URL(string: "file://" + DirectoryConfig.detect().workDir)?.appendingPathComponent(urlComponent) else {
                throw NSError(domain: "Unable to get pwd", code: 0)
            }
            try file.file.write(to: url)
            return req.future(ServerResponse.defaultSuccess)
        }
}
