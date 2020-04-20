//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import UIKit

public extension UINavigationBar {
    func makeTranslucent(_ isTranslucent: Bool) {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        self.isTranslucent = isTranslucent
    }
}
