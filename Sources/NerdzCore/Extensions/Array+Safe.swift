//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension Array {
    
    /// Fetch iteam from array if that exist, or returning `nil` if index out of range
    /// - Parameter index: Element expected index
    subscript(safe index: Int) -> Element? {
        if 0..<self.count ~= index {
            return self[index]
        }

        return nil
    }
}
