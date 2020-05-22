import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
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
    
}
