//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension String {    
    func attributed(with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
}
