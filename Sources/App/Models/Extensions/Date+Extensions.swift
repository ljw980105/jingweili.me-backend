//
//  Date+Extensions.swift
//  
//
//  Created by Jing Wei Li on 10/31/21.
//

import Foundation

extension Date {
    var isoStringOnEST: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "EST")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter.string(from: self)
    }
}
