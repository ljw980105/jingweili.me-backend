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
        return try saveWithFilename("Public/\(type.rawValue)", on: self)
    }
}

private enum PathType {
    case `default`
    case custom(name: String)
    
    func pathComponentFor(_ file: UploadedFile) -> String {
        switch self {
        case .default:
            return "Public/\(file.name)"
        case .custom(name: let name):
            return name
        }
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
    return try saveFile(on: req, pathType: .custom(name: filename))
}

func saveWithOriginalFilename(on req: Request) throws -> Future<ServerResponse> {
    return try saveFile(on: req, pathType: .default)
}

private func saveFile(on req: Request, pathType: PathType) throws -> Future<ServerResponse> {
    return try req
        .content
        .decode(UploadedFile.self)
        .flatMap { file -> Future<ServerResponse> in
            let pathComponent = pathType.pathComponentFor(file)
            guard let url = URL(string: "file://" + DirectoryConfig.detect().workDir)?.appendingPathComponent(pathComponent) else {
                throw NSError(domain: "Unable to get pwd", code: 0)
            }
            try file.file.write(to: url)
            return req.future(ServerResponse.defaultSuccess)
    }
}
