//
//  UITabBarExtension.swift
//  MemoryChainKit
//
//  Created by Marc Steven on 2020/4/17.
//  Copyright © 2020 Marc Steven(https://github.com/MarcSteven). All rights reserved.
//

import UIKit


public extension UITabBar {
    
     var isBorderHidden:Bool {
        get {
            return value(forKey: "_hidesShadow") as? Bool ?? false
        }
        set {
            setValue(newValue, forKey: "_hidesShadow")
        }
        
    }
    
}
