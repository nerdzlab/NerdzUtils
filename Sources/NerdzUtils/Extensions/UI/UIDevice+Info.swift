//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import UIKit

public extension UIDevice {
    
    /// Provides device model
    var model: String? {
        var systemInfo = utsname()
        uname(&systemInfo)

        guard let iOSDeviceModelsPath = Bundle.main.path(forResource: "DeviceModels", ofType: "plist") else { return "" }
        guard let iOSDevices = NSDictionary(contentsOfFile: iOSDeviceModelsPath) else { return "" }

        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return iOSDevices.value(forKey: identifier) as? String
    }
    
    
}
