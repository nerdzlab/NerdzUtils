//
//  File.swift
//  
//
//  Created by new user on 28.08.2021.
//

#if os(iOS)

import UIKit

public extension UIApplication {
    
    /// Opens app native settings
    /// - Returns: `true` if operation was successful
    @discardableResult func openSettings() -> Bool {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return false
        }
        
        open(url)
        return true
    }
}

#endif
