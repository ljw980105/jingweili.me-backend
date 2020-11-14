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
        return try saveWithFilename(type.rawValue, on: self)
    }
}

/// Saves the file contained in the request to the url component specified.
/// - Default behavior will allow the file saved to be overwritten if it's already there.
/// - If the file is uploaded through web, use `formData`, and make sure it has a field named `file`, and a field named `name`, like this:
/// ```
/// formData.append('file', fileToUpload);
/// formData.append('name', name);
/// ```
func saveWithFilename(_ filename: String, on req: Request) throws -> Future<ServerResponse> {
    return try saveFile(on: req, customName: filename)
}

func saveWithOriginalFilename(
    on req: Request,
    directory: DirectoryType = .public) throws -> Future<ServerResponse>
{
    return try saveFile(on: req, directory: directory)
}

/// - Parameters:
///   - customName: If this param is provided then it will override the original file's name
private func saveFile(
    on req: Request,
    customName: String? = nil,
    directory: DirectoryType = .public) throws -> Future<ServerResponse>
{
    return try req
        .content
        .decode(UploadedFile.self)
        .flatMap { file -> Future<ServerResponse> in
            let url = directory.directory.appendingPathComponent(customName ?? file.name)
            print("File \(customName ?? file.name) uploaded to directory \(directory.rawValue)")
            try file.file.write(to: url)
            return req.future(ServerResponse.defaultSuccess)
    }
}
