import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // MARK: - PC Entries
    router.post("api", "add_pc_entry") { req -> Future<ServerResponse> in
       return try req.content
        .decode([PCSetupEntry].self)
        .flatMap(to: [PCSetupEntry].self) { (setups: [PCSetupEntry]) -> Future<[PCSetupEntry]> in
            return setups.save(on: req)
        }
       .transform(to: ServerResponse.defaultSuccess)
    }
    
    router.get("api", "get_pc_entries") { req -> Future<[PCSetupEntry]> in
        return PCSetupEntry.query(on: req).all()
    }
    
    // MARK: - CV + Resumes
    router.post("api", "upload-resume") { (req: Request) -> Future<ServerResponse> in
        return try req.saveFileTyped(.resume)
    }
    
    router.post("api", "upload-cv") { (req: Request) -> Future<ServerResponse> in
        return try req.saveFileTyped(.cv)
    }
    
    router.get("api", "cv") { req -> Future<FileLocation> in
        let exists = FileType.cv.fileExists()
        return req.future(FileLocation(exists: exists, url: exists ? FileType.cv.rawValue : ""))
    }
    
    router.get("api", "resume") { req -> Future<FileLocation> in
        let exists = FileType.resume.fileExists()
        return req.future(FileLocation(exists: exists, url: exists ? FileType.resume.rawValue : ""))
    }
    
    // MARK: - Graphic Design Endpoints
    router.get("api", "get-graphic-projects") { req -> Future<[GraphicProject]> in
        return GraphicProject.query(on: req).all()
    }
    
    router.post("api", "add-graphic-project") { req -> Future<ServerResponse> in
        return try req.content
            .decode(GraphicProject.self)
            .flatMap(to: GraphicProject.self) { $0.save(on: req) }
            .transform(to: ServerResponse.defaultSuccess)
    }
    
    router.delete("api", "delete-graphic-project", GraphicProject.parameter) { req -> Future<ServerResponse> in
        return try req.parameters.next(GraphicProject.self)
            .delete(on: req)
            .transform(to: ServerResponse.defaultSuccess)
    }
    
    // MARK: - File Upload
    router.post("api", "upload-file") { req -> Future<ServerResponse> in
        return try saveWithOriginalFilename(on: req)
    }
}
