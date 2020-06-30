//
//  Future+Extensions.swift
//  App
//
//  Created by Jing Wei Li on 6/28/20.
//

import Foundation
import Vapor
import Fluent

extension Future {
    /// First decode the model object embeded in the request and then saves it in the DB
    func decodeAndSaveOnType<T: Model>(_ type: T.Type, req: Request) -> Future<ServerResponse> {
        return self.flatMap { _ -> Future<T> in // save
            return try req.content
                .decode(T.self)
                .flatMap { $0.save(on: req) }
        }
        .transform(to: req.future(ServerResponse.defaultSuccess))
    }
}
