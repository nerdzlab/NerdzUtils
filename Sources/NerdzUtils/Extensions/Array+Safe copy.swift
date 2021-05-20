//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        if 0..<self.count ~= index {
            return self[index]
        }

        return nil
    }
}
