//
//  Array+OtherExtensions.swift
//  App
//
//  Created by Jing Wei Li on 11/20/20.
//

import Foundation

extension Array {
    func filterMultipleElements<T>(
        using predicate: (Element, T) -> Bool,
        elements: [T]) -> [Element]
    {
        var result = self
        for element in elements {
            result = result.filter { predicate($0, element) }
        }
        return result
    }
}
