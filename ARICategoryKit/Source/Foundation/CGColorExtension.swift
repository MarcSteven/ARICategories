//
//  CGColorExtension.swift
//  MemoryChainKit
//
//  Created by Marc Steven on 2020/3/19.
//  Copyright © 2020 Marc Steven(https://github.com/MarcSteven). All rights reserved.
//

import UIKit
import QuartzCore

public extension CGColor {
    
    /// convert cgcolor to UIColor 
     var uiColor:UIColor {
        return UIColor(cgColor: self)
    }
}
