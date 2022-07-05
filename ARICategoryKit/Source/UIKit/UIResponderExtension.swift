//
//  UIResponderExtension.swift
//  MemoryChainKit
//
//  Created by Marc Zhao on 2020/3/10.
//  Copyright © 2020 Marc Zhao(https://github.com/MarcSteven). All rights reserved.
//

import UIKit

public extension UIResponder {
    func responderChain() ->String {
        guard let next = next else {
            return String(describing: self)
        }
        return String(describing: self) + "->" + next.responderChain()
    }
}

extension UIResponder {
    
    /**
     
     /// ```swift
        /// extension UICollectionViewCell {
        ///     func configure() {
        ///         if let collectionView = responder() as? UICollectionView {
        ///
        ///         }
        ///     }
        /// }
        /// ```
     
     */
    open func responder<T:UIResponder>() ->T? {
        var responder :UIResponder = self
        while let nextResponder = responder.next {
            responder = nextResponder
            if responder is T {
                return responder as? T
            }
        }
        return nil
    }
}

//https://stackoverflow.com/questions/1372977/given-a-view-how-do-i-get-its-viewcontroller
public extension UIResponder {
   
        func parentController<T: UIViewController>(of type: T.Type) -> T? {
            guard let next = self.next else {
                return nil
            }
            return (next as? T) ?? next.parentController(of: T.self)
        }
    

}
/** usage
 
 class myView:UIView {
 
    let parentViewController =  self.parentController(of:MyViewController.self)
 
 }
 
 
 
 */


public extension UIResponder {
   // Thanks to Phil M
   // http://stackoverflow.com/questions/1340434/get-to-uiviewcontroller-from-uiview-on-iphone
   
   func firstAvailableViewController() -> UIViewController? {
       // convenience function for casting and to "mask" the recursive function
       return self.traverseResponderChainForFirstViewController()
   }
   
   private func traverseResponderChainForFirstViewController() -> UIViewController? {
       if let nextResponder = self.next {
           if nextResponder is UIViewController {
               return nextResponder as? UIViewController
           } else if nextResponder is UIView {
               return nextResponder.traverseResponderChainForFirstViewController()
           } else {
               return nil
           }
       }
       return nil
   }
}

