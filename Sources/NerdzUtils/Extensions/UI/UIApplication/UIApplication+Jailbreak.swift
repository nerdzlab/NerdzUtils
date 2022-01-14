//
//  UIApplication+Jailbreak.swift
//  NerdzUtils
//
//  Created by new user on 01.08.2021.
//

import UIKit

#if canImport(UIKit)

import UIKit

public extension NZUTilsExtensionData where Base: UIApplication {
    
    /// Verifying if current device might be jailbroken
    var isJailbroken: Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt") ||
            fileManager.fileExists(atPath: "/usr/bin/ssh") {
            return true
        }
        
        if canOpen("/Applications/Cydia.app") ||
            canOpen("/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            canOpen("/bin/bash") ||
            canOpen("/usr/sbin/sshd") ||
            canOpen("/etc/apt") ||
            canOpen("/usr/bin/ssh") {
            return true
        }
        
        let randomWritingPath = "/private/" + UUID().uuidString
        
        do {
            try "anyString".write(toFile: randomWritingPath, atomically: true, encoding: .utf8)
            try fileManager.removeItem(atPath: randomWritingPath)
            return true
        }
        catch {
            return false
        }
        #endif
    }
    
    private func canOpen(_ path: String) -> Bool {
        let file = fopen(path, "r")
        
        guard file != nil else {
            return false
        }
        
        fclose(file)
        
        return true
    }
}

#endif
