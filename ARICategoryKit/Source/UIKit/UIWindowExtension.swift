//
//  UIWindowExtension.swift
//  ARICategoryKit
//
//  Created by marc zhao on 2022/4/12.
//

import Foundation
import  UIKit

public extension UIWindow {
    static var key: UIWindow? {
            if #available(iOS 13, *) {
                
                if #available(iOS 15, *) {
                    return UIApplication
                        .shared
                        .connectedScenes
                        .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                        .first { $0.isKeyWindow }
                }else {
                
                
                return UIApplication.shared.windows.first { $0.isKeyWindow }
                }
                }
       
        else {
                return UIApplication.shared.keyWindow
            }
        }
}

public extension UIWindow {
    
    /// get the top view controller in the UIWindow
    /// - Returns: return the top view controller
    func topViewController()->UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            }else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            }else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            }else {
                break
            }
        }
        return top
    }
}



public extension UIWindow {
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {

        var rootVC = rootViewController
        if rootVC == nil {
            if #available(iOS 15.0, *) {
                let keyWindow =  UIApplication.shared.connectedScenes
                // Keep only active scenes, onscreen and visible to the user
                .filter { $0.activationState == .foregroundActive }
                // Keep only the first `UIWindowScene`
                .first(where: { $0 is UIWindowScene })
                // Get its associated windows
                .flatMap({ $0 as? UIWindowScene })?.windows
                // Finally, keep only the key window
                .first(where: \.isKeyWindow)
                rootVC = keyWindow?.rootViewController
            } else {
                rootVC = UIApplication.shared.keyWindow?.rootViewController
            }
           
        }

        if rootVC?.presentedViewController == nil {
            return rootVC
        }

        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }

            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }

            return getVisibleViewController(presented)
        }
        return nil
    }
}




public extension UIWindow {
    
    static var isLandscape: Bool {
           if #available(iOS 13.0, *) {
               
               if #available(iOS 15.0, *) {
                   let scenes = UIApplication.shared.connectedScenes
                   let windowScene = scenes.first as? UIWindowScene
                   let window = windowScene?.windows.first
                   
                   return window?.windowScene?.interfaceOrientation.isLandscape ?? false
                   
                   
                   
               }else {
               return UIApplication.shared.windows
                   .first?
                   .windowScene?
                   .interfaceOrientation
                   .isLandscape ?? false
           }
           }
        else {
               return UIApplication.shared.statusBarOrientation.isLandscape
           }
       }
    static var isPortrait:Bool {
        if #available(iOS 13.0, *) {
            if #available(iOS 15.0, *) {
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                
                
                return window?.windowScene?.interfaceOrientation.isPortrait ?? false
            }else {
                return UIApplication.shared.windows
                    .first?
                    .windowScene?
                    .interfaceOrientation
                    .isPortrait ?? false
            }
        }
        else {
            return UIApplication.shared.statusBarOrientation.isPortrait
        }
    }
}
