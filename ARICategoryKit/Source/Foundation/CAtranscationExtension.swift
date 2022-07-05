//
//  CAtranscationExtension.swift
//  MemoryChainKit
//
//  Created by Marc Steven on 2020/3/19.
//  Copyright © 2020 Marc Steven(https://github.com/MarcSteven). All rights reserved.
//

import QuartzCore
import UIKit

public extension CATransaction {
    
    /// animation
    /// - Parameters:
    ///   - animations: animations
    ///   - completinonHandler: completionHandler
     static func animation(_ animations:() ->Void,completinonHandler:(() ->Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completinonHandler)
        animations()
        CATransaction.commit()
        
    }
    
    /// perform without animation
    /// - Parameter actionsWithouAnimation: actionsWithoutAnimation
     static func performWithoutAnimation(_ actionsWithouAnimation:()->Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        actionsWithouAnimation()
        CATransaction.commit()
    }
}
public extension CATransitionType {
    
    /// none
     static let none = CATransitionType(rawValue: "")
    
    
    
}
