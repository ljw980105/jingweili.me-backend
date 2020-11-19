//
//  DirectoryInfo.swift
//  App
//
//  Created by Jing Wei Li on 11/14/20.
//

import Foundation
import Vapor

private let resourceKeys: [URLResourceKey] = [.volumeTotalCapacityKey, .volumeAvailableCapacityKey]

struct DirectoryInfo: Content {
    let totalCapacity: Int64?
    let availableCapacity: Int64?
    let usedCapacity: Int64?
    
    init(url: URL) throws {
        let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys)).allValues
        totalCapacity = resourceValues[.volumeTotalCapacityKey] as? Int64
        availableCapacity = resourceValues[.volumeAvailableCapacityKey] as? Int64
        if let total = totalCapacity, let available = availableCapacity {
            usedCapacity = total - available
        } else {
            usedCapacity = nil
        }
    }
}
