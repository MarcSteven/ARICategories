//
//  UIViewControllerExtension.swift
//  ARICategoryKit
//
//  Created by marc zhao on 2022/3/30.
//

import UIKit
import SafariServices




public extension UIViewController {
    static var supportedURLSchemes = ["http","https"]
    func goTo(url:URL) {
        if let scheme = url.scheme?.lowercased(), UIViewController.supportedURLSchemes.contains(scheme) {
            let controller = SFSafariViewController(url: url)
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated:true)
        } else  {
            
        }
    }
}

// http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
public  extension UIViewController {

    var isTopAndVisible: Bool {
        return isVisible && isTopViewController
    }

    var isVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }

    var isTopViewController: Bool {
        if self.navigationController != nil {
            return self.navigationController?.visibleViewController === self
        } else if self.tabBarController != nil {
            return self.tabBarController?.selectedViewController == self && self.presentedViewController == nil
        } else {
            return self.presentedViewController == nil && self.isVisible
        }
    }
}
public extension  UIViewController {
    
    /// Removes the view controller from its parent.
     func removeFromContainerViewController() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    
    /// A boolean value to determine whether the view controller is being popped or is showing a subview controller.
     var isBeingPopped: Bool {
        if isMovingFromParent || isBeingDismissed {
            return true
        }

        if let viewControllers = navigationController?.viewControllers, viewControllers.contains(self) {
            return false
        }

        return false
    }

     var isModal: Bool {
        if presentingViewController != nil {
            return true
        }

        if presentingViewController?.presentedViewController == self {
            return true
        }

        if let navigationController = navigationController, navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        }

        if (tabBarController?.presentingViewController?.isKind(of: UITabBarController.self)) != nil {
            return true
        }

        return false
    }

    /// A boolean value indicating whether the view is currently loaded into memory
    /// and presented on the screen.
     var isPresented: Bool {
        isViewLoaded && view.window != nil
    }

    /// A boolean value indicating whether the home indicator is currently present.
     var isHomeIndicatorPresent: Bool {
        if #available(iOS 11, *) {
            return view.safeAreaInsets.bottom > 0
        } else {
            return false
        }
    }

 

    /// Returns the physical orientation of the device.
     var isDeviceLandscape: Bool {
        UIDevice.current.orientation.isLandscape
    }

    /// This value represents the physical orientation of the device and may be different
    /// from the current orientation of your application’s user interface.
    ///
    /// - seealso: `UIDeviceOrientation` for descriptions of the possible values.
     var deviceOrientation: UIDeviceOrientation {
        UIDevice.current.orientation
    }


    
    
}
//MARK: - hide navigation Bar
public extension UIViewController {
//    https://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift
    func hideNavigationBar(animated: Bool){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    func showNavigationBar(animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
public extension UIViewController {
    func hideNavigationBarOnTap() {
        if self.navigationController?.navigationBar.isHidden == true  {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }else if self.navigationController?.navigationBar.isHidden == false {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}
public extension UIViewController {
    func hideNavigationBackTitle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            }
}
public extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func hideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
//Usage : called this method of hideKeyboardOnTap in viewDidLoad()
public extension UIViewController {
    private struct AssociatedKeys {
           static var floatingButton:UIButton?
       }
       /// floating button
       var floatingButton:UIButton? {
           get {
               guard let value = objc_getAssociatedObject(self, &AssociatedKeys.floatingButton) as? UIButton else {
                   return  nil
               }
               return value
           }
           set {
               objc_setAssociatedObject(self, &AssociatedKeys.floatingButton, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
       }
       //Add floating button
       func addFloatingButton(_ usingImage:UIImage) {
               // Customize your own floating button UI
               let button = UIButton(type: .custom)
               let image = usingImage.withRenderingMode(.alwaysTemplate)
               button.tintColor = .white
               button.setImage(image, for: .normal)
              
               button.layer.shadowColor = UIColor.black.cgColor
               button.layer.shadowRadius = 3
               button.layer.shadowOpacity = 0.12
               button.layer.shadowOffset = CGSize(width: 0, height: 1)
               button.sizeToFit()
               let buttonSize = CGSize(width: 64, height: 56)
               let rect = UIScreen.main.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
               button.frame = CGRect(origin: CGPoint(x: rect.maxX - 15, y: rect.maxY - 50), size: CGSize(width: 60, height: 60))
               // button.cornerRadius = 30 -> Will destroy your shadows, however you can still find workarounds for rounded shadow.
               button.autoresizingMask = []
               view.addSubview(button)
               floatingButton = button
               let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire(panGesture:)))
               floatingButton?.addGestureRecognizer(panner)
               snapButtonToSocket()
           }
       
       /// pangestrure did fire
       /// - Parameter panner: panGestureRecognizer
           @objc fileprivate func panDidFire(panGesture: UIPanGestureRecognizer) {
               guard let floatingButton = floatingButton else {return}
               let offset = panGesture.translation(in: view)
               panGesture.setTranslation(CGPoint.zero, in: view)
               var center = floatingButton.center
               center.x += offset.x
               center.y += offset.y
               floatingButton.center = center

               if panGesture.state == .ended || panGesture.state == .cancelled {
                   UIView.animate(withDuration: 0.3) {
                       self.snapButtonToSocket()
                   }
               }
           }
       /// snap button to socket
           fileprivate func snapButtonToSocket() {
               guard let floatingButton = floatingButton else {return}
               var bestSocket = CGPoint.zero
               var distanceToBestSocket = CGFloat.infinity
               let center = floatingButton.center
               for socket in sockets {
                   let distance = hypot(center.x - socket.x, center.y - socket.y)
                   if distance < distanceToBestSocket {
                       distanceToBestSocket = distance
                       bestSocket = socket
                   }
               }
               floatingButton.center = bestSocket
           }
       
       /// sockets
           fileprivate var sockets: [CGPoint] {
               let buttonSize = floatingButton?.bounds.size ?? CGSize(width: 0, height: 0)
               let rect = view.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
               let sockets: [CGPoint] = [
                   CGPoint(x: rect.minX + 15, y: rect.minY + 30),
                   CGPoint(x: rect.minX + 15, y: rect.maxY - 50),
                   CGPoint(x: rect.maxX - 15, y: rect.minY + 30),
                   CGPoint(x: rect.maxX - 15, y: rect.maxY - 50)
               ]
               return sockets
           }
           // Custom socket position to hold Y position and snap to horizontal edges.
           // You can snap to any coordinate on screen by setting custom socket positions.
           fileprivate var horizontalSockets: [CGPoint] {
               guard let floatingButton = floatingButton else {return []}
               let buttonSize = floatingButton.bounds.size
               let rect = view.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
               let y = min(rect.maxY - 50, max(rect.minY + 30, floatingButton.frame.minY + buttonSize.height / 2))
               let sockets: [CGPoint] = [
                   CGPoint(x: rect.minX + 15, y: y),
                   CGPoint(x: rect.maxX - 15, y: y)
               ]
               return sockets
           }
   }
public extension UIViewController {
    @objc var topBarHeight: CGFloat {
        if #available(*, iOS 13) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
        }
    }
}


public extension UIViewController {
    func openSettings() {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
// Get the top from UIViewController  https://stackoverflow.com/questions/11637709/get-the-current-displaying-uiviewcontroller-on-the-screen-in-appdelegate-m
public extension UIViewController {
    var top: UIViewController? {
        if let controller = self as? UINavigationController {
            return controller.topViewController?.top
        }
        if let controller = self as? UISplitViewController {
            return controller.viewControllers.last?.top
        }
        if let controller = self as? UITabBarController {
            return controller.selectedViewController?.top
        }
        if let controller = presentedViewController {
            return controller.top
        }
        return self
    }
}


/// Conform to `AlertPresenting` protocol to present alerts from a view controller.
public protocol AlertPresenting: AnyObject {
    
    /// Present alert.
    ///
    /// - Parameters:
    ///   - title: alert title.
    ///   - message: alert message.
    ///   - preferredStyle: alert preferred style.
    ///   - tintColor: alert tint color.
    ///   - actions: alert actions array.
    ///   - animated: set to true to animate alert presentation.
    ///   - completion: optional completion handler is called after the alert is presented.
    /// - Returns: presented alert.
    @discardableResult func presentAlert(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        tintColor: UIColor?,
        actions: [UIAlertAction],
        animated: Bool,
        completion: (() -> Void)?) -> UIAlertController
    
    /// Present alert from an error.
    ///
    /// - Parameters:
    ///   - title: alert title.
    ///   - error: error.
    ///   - preferredStyle: alert preferred style.
    ///   - tintColor: alert tint color.
    ///   - actions: alert actions array.
    ///   - animated: set to true to animate alert presentation.
    ///   - completion: optional completion handler is called after the alert is presented.
    /// - Returns: presented alert.
    @discardableResult func presentAlert(
        title: String?,
        error: Error,
        preferredStyle: UIAlertController.Style,
        tintColor: UIColor?,
        actions: [UIAlertAction],
        animated: Bool,
        completion: (() -> Void)?) -> UIAlertController
    
}

// MARK: - Default implementation for UIViewController.
public extension AlertPresenting where Self: UIViewController {
    
    /// Present alert.
    ///
    /// - Parameters:
    ///   - title: alert title.
    ///   - message: alert message.
    ///   - preferredStyle: alert preferred style _(default is .alert)_.
    ///   - tintColor: alert tint color _(default is nil)_.
    ///   - actions: alert actions array _(default is empty)_.
    ///   - animated: set to true to animate alert presentation _(defalt is true)_.
    ///   - completion: optional completion handler is called after the alert is presented _(default is nil)_.
    /// - Returns: presented alert.
    @discardableResult func presentAlert(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style = .alert,
        tintColor: UIColor? = nil,
        actions: [UIAlertAction] = [],
        animated: Bool = true,
        completion: (() -> Void)? = nil) -> UIAlertController {
        
        let alert = self.alert(title: title, message: message, preferredStyle: preferredStyle, actions: actions, animated: animated)
        
        if let color = tintColor {
            alert.view.tintColor = color
        }
        
        present(alert, animated: animated, completion: completion)
        
        if let color = tintColor {
            alert.view.tintColor = color
        }
        
        return alert
    }
    
    /// Present alert from an error.
    ///
    /// - Parameters:
    ///   - title: alert title.
    ///   - error: error.
    ///   - preferredStyle: alert preferred style _(default is .alert)_.
    ///   - tintColor: alert tint color _(default is nil)_.
    ///   - actions: alert actions array _(default is empty)_.
    ///   - animated: set to true to animate alert presentation _(defalt is true)_.
    ///   - completion: optional completion handler is called after the alert is presented _(default is nil)_.
    /// - Returns: presented alert.
    @discardableResult func presentAlert(
        title: String?,
        error: Error,
        preferredStyle: UIAlertController.Style = .alert,
        tintColor: UIColor? = nil,
        actions: [UIAlertAction] = [],
        animated: Bool = true,
        completion: (() -> Void)? = nil) -> UIAlertController {
        
        let alert = self.alert(title: title, message: error.localizedDescription, preferredStyle: preferredStyle, actions: actions, animated: animated)
        
        if let color = tintColor {
            alert.view.tintColor = color
        }
        
        present(alert, animated: animated, completion: completion)
        
        if let color = tintColor {
            alert.view.tintColor = color
        }
        
        return alert
    }
    
}

// MARK: - Private UIViewController extension to show alerts.
public extension UIViewController {
    
    /// Creates an alert.
    ///
    /// - Parameters:
    ///   - title: alert title.
    ///   - message: alert message.
    ///   - preferredStyle: alert preferred style _(default is .alert)_.
    ///   - actions: alert actions array _(default is empty)_.
    ///   - animated: wether presentation is animated or not _(default is true)_.
    /// - Returns: UIAlertController instance.
    @discardableResult func alert(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        actions: [UIAlertAction] = [],
        animated: Bool = true) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if actions.isEmpty {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
        }
        
        for action in actions {
            alert.addAction(action)
        }
        
        return alert
    }
    
}


public extension UIViewController {
    
        /// Loads a `UIViewController` of type `T` with storyboard. Assumes that the storyboards Storyboard ID has the same name as the storyboard and that the storyboard has been marked as Is Initial View Controller.
        /// - Parameter storyboardName: Name of the storyboard without .xib/nib suffix.
        static func loadFromStoryboard<T: UIViewController>(_ storyboardName: String) -> T? {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: storyboardName) as? T {
                vc.loadViewIfNeeded() // ensures vc.view is loaded before returning
                return vc
            }
            return nil
        }
}


public extension UIViewController {
    
        func openAppSystemSettingsAlert(title: String, message: String) {
               let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
               let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                   guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                   if UIApplication.shared.canOpenURL(settingsUrl) {
                       UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                           #if DEBUG
                           print("Settings opened: \(success)") // Prints true
                           #endif
                       })
                   }
               }
               alertController.addAction(settingsAction)
               let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
               alertController.addAction(cancelAction)
               present(alertController, animated: true, completion: nil)
           }
    func openBluetoothSettingAlert(title:String,message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let bluetoothAction = UIAlertAction(title: "Enable Bluetooth", style: .default) { (_) in
            guard let bluetoothURL = URL(string: AppPrefs.bluetooth.rawValue) else {
                return
            }
            if UIApplication.shared.canOpenURL(bluetoothURL) {
                UIApplication.shared.open(bluetoothURL,completionHandler: {(success) in
                    #if DEBUG
                    print("Bluetooth opened: \(success)") // Print true
                    #endif
                })
            }
        }
        alertController.addAction(bluetoothAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
        
       }

public extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func hideKeyboardWhenTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    

}
//Usage : called this method of hideKeyboardOnTap in viewDidLoad()

public extension UIViewController {
    
    func addNavigationBarButton(imageName:String,direction:direction){
        var image = UIImage(named: imageName)
        image = image?.withRenderingMode(.alwaysOriginal)
        switch direction {
        case .left:
           self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: nil, action: #selector(goBack))
        case .right:
           self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: nil, action: #selector(goBack))
        }
    }

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    enum direction {
        case right
        case left
    }
}
extension UIViewController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}


public enum AppPrefs:String {
    case wifi = "App-Prefs:root=WIFI"
    case bluetooth = "App-Prefs:root=Bluetooth"
    case mobileDataSetting = "App-Prefs:root=MOBILE_DATA_SETTINGS_ID"
    case internetTethering = "App-Prefs:root=INTERNET_TETHERING"
    case carries = "App-Prefs:root=Carrier"
    case notificationID = "App-Prefs:root=NOTIFICATIONS_ID"
    case generals = "App-Prefs:root=General"
    case generalAbout = "App-Prefs:root=General&path=About"
    case keyboard = "App-Prefs:root=General&path=Keyboard"
    case accesssiblitys = "App-Prefs:root=General&path=ACCESSIBILITY"
}
/**
 
 
 
 App-Prefs:root=General&path=About
 通用-键盘    App-Prefs:root=General&path=Keyboard
 通用-辅助功能    App-Prefs:root=General&path=ACCESSIBILITY
 通用-语言与地区    App-Prefs:root=General&path=INTERNATIONAL
 通用-还原    App-Prefs:root=Reset
 墙纸    App-Prefs:root=Wallpaper
 Siri    App-Prefs:root=SIRI
 隐私    App-Prefs:root=Privacy
 Safari    App-Prefs:root=SAFARI
 音乐    App-Prefs:root=MUSIC
 音乐-均衡器    App-Prefs:root=MUSIC&path=com.apple.Music:EQ
 照片与相机    App-Prefs:root=Photos
 FaceTime    App-Prefs:root=FACETIME

 
 */
