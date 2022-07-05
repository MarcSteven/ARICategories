//
//  CGSize+Extension.swift
//  MemoryChainKit
//
//  Created by Marc Zhao on 2019/1/29.
//  Copyright © 2019 Memory Chain technology(China) co,LTD. All rights reserved.
//

import Foundation
import UIKit


extension CGSize :ExpressibleByFloatLiteral{
    public typealias FloatLiteralType = Double
     init(size:Double) {
        self.init(width: size, height: size)
    }
    
    /// init method
    /// - Parameter value: float  literal
    public init(floatLiteral value:FloatLiteralType) {
        self.init(size: value)
    }
    
    /// aspect ratio
    public var aspectRatio:CGFloat {
        return width / height
    }
    
    /// size By delta
    /// - Parameters:
    ///   - dw: d width
    ///   - dh: d height
    /// - Returns: return delta size 
    public func sizeByDelta(dw:CGFloat,
                     dh:CGFloat) ->CGSize {
        return CGSize(width: self.width + dw,height: self.height + dh)
    }
  
}
