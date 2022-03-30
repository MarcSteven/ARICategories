//
//  UINavigationControllerExtension.swift
//  MemoryChainKit
//
//  Created by Marc Steven on 2020/3/17.
//  Copyright © 2020 Marc Steven(https://github.com/MarcSteven). All rights reserved.
//

import UIKit

public extension UINavigationController {
    var rootViewController:UIViewController? {
        get {
            viewControllers.first
        }
        set {
            var rootViewController:[UIViewController] = []
            if let viewController = newValue {
                rootViewController = [viewController]
            }
            setViewControllers(rootViewController, animated: false)
        }
    }
    
   
     func popViewController(animated:Bool,
                                  completion:(() ->Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    func pushViewController(_ viewController:UIViewController,
                            completionHandler: (()->Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionHandler)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }

}



//MARK: - UINavigationController extension to add bottom line
@objc public extension UINavigationController {
    
    
    //MARK : - Add bottom line to the NavigationBarController
    
    
        func addBottomLine(color:UIColor,height:Double)
        {
            //Hiding Default Line and Shadow
            navigationBar.setValue(true, forKey: "hidesShadow")
        
            //Creating New line
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width:0, height: height))
            lineView.backgroundColor = color
            navigationBar.addSubview(lineView)
        
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.widthAnchor.constraint(equalTo: navigationBar.widthAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            lineView.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
            lineView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        }
    }

