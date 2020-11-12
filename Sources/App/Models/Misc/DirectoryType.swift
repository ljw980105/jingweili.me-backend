//
//  DirectoryType.swift
//  App
//
//  Created by Jing Wei Li on 11/11/20.
//

import Foundation

enum DirectoryType: String {
    /// public path where most resources of the website are served
    case `public` = "Public/resources/"
    /// root path. Many sensitive files are served here
    case root = ""
    /// Path of the private file server
    case `private` = "Private/"
    
    var directory: URL {
        pwd().appendingPathComponent(rawValue)
    }
    
    init?(string: String) {
        switch string {
        case "public":
            self = .public
        case "private":
            self = .private
        default:
            return nil
        }
    }
}

