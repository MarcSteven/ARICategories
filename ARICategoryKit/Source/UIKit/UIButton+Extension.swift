//
//  UIButton+Extension.swift
//  MemoryChain
//
//  Created by Marc Zhao on 2018/8/4.
//  Copyright © 2018年 Memory Chain technology(China) co,LTD. All rights reserved.
//

#if canImport(UIKit)
import UIKit

#if !os(watchOS)



public extension UIButton {
    func build(block:(UIButton)->Void)->UIButton {
        let button = UIButton(frame: .zero)
        block(button)
        return button
    }
}
fileprivate let minimumHitArea = CGSize(width: 44, height: 44)

extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if the button is hidden/disabled/transparent it can't be hit
        if isHidden || !isUserInteractionEnabled || alpha < 0.01 { return nil }

        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)

        // perform hit test on larger frame
        return (largerFrame.contains(point)) ? self : nil
    }
}

public extension UIButton {
  
 static func createSystemButton(withTitle title: String)
    -> UIButton {
      let button = UIButton(type: .system)
      button.setTitle(title, for: .normal)
      return button
  } 
}

//MARK: - animation for UIButton
public extension UIButton {
    
    
    //MARK: - Public Methods
    func setTitleColor(color:UIColor) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color.withAlphaComponent(0.7), for: .highlighted)
    }
    func removeAllTargets() {
        self.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    func setTitle(_ title: String?, for state: UIControl.State, animated: Bool) {
        if animated {
            setTitle(title, for: state)
        }
        else {
            UIView .performWithoutAnimation {
                setTitle(title, for: state)
                layoutIfNeeded()
            }
        }
    }
    
    func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State, animated: Bool) {
        if animated {
            setAttributedTitle(title, for: state)
        }
        else {
            UIView .performWithoutAnimation {
                setAttributedTitle(title, for: state)
                layoutIfNeeded()
            }
        }
    }
}
public extension UIButton {
    /// The image used for the normal state.
        var image: UIImage? {
           get { image(for: .normal) }
           set { setImage(newValue, for: .normal) }
       }

       /// The image used for the highlighted state.
        var highlightedImage: UIImage? {
           get { image(for: .highlighted) }
           set { setImage(newValue, for: .highlighted) }
       }

       /// The text used for the normal state.
        var text: String? {
           get { title(for: .normal) }
           set { setTitle(newValue, for: .normal) }
       }

       /// The text used for the highlighted state.
        var highlightedText: String? {
           get { title(for: .highlighted) }
           set { setTitle(newValue, for: .highlighted) }
       }

       /// The attributed text used for the normal state.
        var attributedText: NSAttributedString? {
           get { attributedTitle(for: .normal) }
           set { setAttributedTitle(newValue, for: .normal) }
       }

       /// The attributed text used for the highlighted state.
        var highlightedAttributedText: NSAttributedString? {
           get { attributedTitle(for: .highlighted) }
           set { setAttributedTitle(newValue, for: .highlighted) }
       }

       /// The color of the title used for the normal state.
        var textColor: UIColor? {
           get { titleColor(for: .normal) }
           set { setTitleColor(newValue, for: .normal) }
       }

       /// The color of the title used for the highlighted state.
        var highlightedTextColor: UIColor? {
           get { titleColor(for: .highlighted) }
           set { setTitleColor(newValue, for: .highlighted) }
       }


       /// Add space between `text` and `image` while preserving the `intrinsicContentSize` and respecting `sizeToFit`.
       @IBInspectable
        var textImageSpacing: CGFloat {
           get {
               if #available(iOS 15.0, *) {
                   
                   let (left,right) = ( self.configuration!.contentInsets.leading,self.configuration!.contentInsets.trailing)
                   if left + right == 0 {
                       return right * 2
                   }else  {
                   
                   return 0
                   }
                   
               }else {
                   let (left, right) = (imageEdgeInsets.left, imageEdgeInsets.right)

                   if left + right == 0 {
                       return right * 2
                   } else {
                       return 0
                   }
                   
               }
              
               
           }
               
           
           set {
               let insetAmount = newValue / 2
               if #available(iOS 15.0, *) {
                   
               }else {
               imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
               titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
               contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
               }
               }
       }

     
       

      
}
//Usage： button.flash()

// MARK: - Properties
public extension UIButton {
    
    ///  Image of disabled state for button; also inspectable from Storyboard.
    @IBInspectable var imageForDisabled: UIImage? {
        get {
            return image(for: .disabled)
        }
        set {
            setImage(newValue, for: .disabled)
        }
    }
    
    ///  Image of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable var imageForHighlighted: UIImage? {
        get {
            return image(for: .highlighted)
        }
        set {
            setImage(newValue, for: .highlighted)
        }
    }
    
    ///  Image of normal state for button; also inspectable from Storyboard.
    @IBInspectable var imageForNormal: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    ///  Image of selected state for button; also inspectable from Storyboard.
    @IBInspectable var imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }
    
    ///  Title color of disabled state for button; also inspectable from Storyboard.
    @IBInspectable var titleColorForDisabled: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }
    
    ///  Title color of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable var titleColorForHighlighted: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }
    
    ///  Title color of normal state for button; also inspectable from Storyboard.
    @IBInspectable var titleColorForNormal: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    ///  Title color of selected state for button; also inspectable from Storyboard.
    @IBInspectable var titleColorForSelected: UIColor? {
        get {
            return titleColor(for: .selected)
        }
        set {
            setTitleColor(newValue, for: .selected)
        }
    }
    
    ///  Title of disabled state for button; also inspectable from Storyboard.
    @IBInspectable var titleForDisabled: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }
    
    ///  Title of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable var titleForHighlighted: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }
    
    ///  Title of normal state for button; also inspectable from Storyboard.
    @IBInspectable var titleForNormal: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    ///  Title of selected state for button; also inspectable from Storyboard.
    @IBInspectable var titleForSelected: String? {
        get {
            return title(for: .selected)
        }
        set {
            setTitle(newValue, for: .selected)
        }
    }
    
}
public extension UIButton {
    func mc_enableMultiLineTitle(textAlignment:NSTextAlignment = .center) {
        guard let titleLabel = self.titleLabel else {
            return
        }
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = textAlignment
    }
}

// MARK: - Methods
public extension UIButton {
    // 设置按钮光晕（阴影）效果
    func setShadow(color: CGColor) {
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 6, height: 6)
        self.layer.shadowColor = color
    }
    
    // 设置字体加粗
    func setTextBold(_ fontName:String,
                     size:CGFloat) {
        self.titleLabel?.font = UIFont(name: fontName  , size: size)
    }
    
    private var states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    ///  Set image for all states.
    ///
    /// - Parameter image: UIImage.
    func setImageForAllStates(_ image: UIImage) {
        states.forEach { self.setImage(image, for: $0) }
    }
    
    ///  Set title color for all states.
    ///
    /// - Parameter color: UIColor.
    func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { self.setTitleColor(color, for: $0) }
    }
    
    ///  Set title for all states.
    ///
    /// - Parameter title: title string.
    func setTitleForAllStates(_ title: String) {
        states.forEach { self.setTitle(title, for: $0) }
    }
    
    ///  Center align title text and image on UIButton
    ///
    /// - Parameter spacing: spacing between UIButton title text and UIButton Image.
    func centerImageAndText(spacing: CGFloat) {
        let insetAmount = spacing / 2
        if #available(iOS 15.0, *) {
            
        }else  {
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
        }
    
    
    static func navBackBtn() -> UIButton {
        // 设置返回按钮属性
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"Arrow"), for: .normal)
        backBtn.titleLabel?.isHidden=true
        backBtn.contentHorizontalAlignment = .left
        if #available(iOS 15.0, *) {
            
        } else {
            backBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10,bottom: 0,right: 0)
        }
        
        let btnW: CGFloat = UIScreen.main.bounds.size.width > 375.0 ? 60 : 44
        backBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: 40)
        return backBtn
    }
}
public extension UIButton {
    func verticalCenterImageAndTitle(withSpacing spacing: CGFloat) {
        let imageSize = imageView?.intrinsicContentSize
        let titleSize = titleLabel?.intrinsicContentSize
        let totalHeight = (imageSize?.height ?? 0.0) + (titleSize?.height ?? 0.0) + spacing
        if #available(iOS 15.0, *) {
            
        } else {
            imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - (imageSize?.height ?? 0.0)), left: 0.0, bottom: 0.0, right: -(titleSize?.width ?? 0.0))
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -(imageSize?.width ?? 0.0), bottom: -(totalHeight - (titleSize?.height ?? 0.0)), right: 0.0)
        }
        
}
}

// timer button
public extension UIButton {
    func addTimerButton(time: NSInteger,
                        btnNormalBgColor: UIColor,
                        btnNormalBorderColor: UIColor,
                        btnNormalTitle: String,
                        btnNormalTitleColor: UIColor,
                        btnSelectedBgColor: UIColor,
                        btnSelectedBorderColor: UIColor,
                        btnSelectedTitleColor: UIColor
                        ) {
        self.backgroundColor? = btnSelectedBgColor.withAlphaComponent(0.4)
        weak var weakSelf = self
        var timeOut:NSInteger = time
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: .seconds(1))
        timer.setEventHandler {
            if timeOut < 0{
                timer.cancel()
                DispatchQueue.main.async(execute: {
                    weakSelf?.setTitle(btnNormalTitle, for: .normal)
                    weakSelf?.setTitleColor(btnNormalTitleColor, for: .normal)
                    weakSelf?.backgroundColor = btnNormalBgColor
                   
                    weakSelf?.isUserInteractionEnabled = true
                })
            } else {
                let allTime = time + 1
                let seconds = timeOut % allTime
                let timeString = String(seconds)
                DispatchQueue.main.async(execute: {
                    weakSelf?.setTitle(timeString, for: .normal)
                    weakSelf?.setTitleColor(btnSelectedTitleColor, for: .normal)

                    weakSelf?.isUserInteractionEnabled = false
                })
                timeOut -= 1
            }
        }
        timer.resume()
    }
}
    
//  MARK: - 设定button点击的时间间隔，防止用户不停点击button
 extension UIButton {
    private struct AssociatedKeys {
           static var eventInterval = "eventInterval"
           static var eventUnavailable = "eventUnavailable"
       }

            /// Time of repeated clicks Property settings
      open var eventInterval: TimeInterval {
           get {
               if let interval = objc_getAssociatedObject(self, &AssociatedKeys.eventInterval) as? TimeInterval {
                   return interval
               }
               return 0.5
           }
           set {
               objc_setAssociatedObject(self, &AssociatedKeys.eventInterval, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
       }

            /// button not pointable property setting
       private var eventUnavailable : Bool {
           get {
               if let unavailable = objc_getAssociatedObject(self, &AssociatedKeys.eventUnavailable) as? Bool {
                   return unavailable
               }
               return false
           }
           set {
               objc_setAssociatedObject(self, &AssociatedKeys.eventUnavailable, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
       }

           
      open class func initializeMethod() {
           let selector = #selector(UIButton.sendAction(_:to:for:))
           let newSelector = #selector(ms_sendAction(_:to:for:))
           
           let method: Method = class_getInstanceMethod(UIButton.self, selector)!
           let newMethod: Method = class_getInstanceMethod(UIButton.self, newSelector)!
           
           if class_addMethod(UIButton.self, selector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
               class_replaceMethod(UIButton.self, newSelector, method_getImplementation(method), method_getTypeEncoding(method))
           } else {
               method_exchangeImplementations(method, newMethod)
           }
       }

            /// In this method
       @objc private func ms_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
           if eventUnavailable == false {
               eventUnavailable = true
               ms_sendAction(action, to: target, for: event)
                            // delay
               DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + eventInterval, execute: {
                   self.eventUnavailable = false
               })
           }
       }
   }
   



#endif
public extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}

// give the button to add title /image/etc


public extension UIButton {
    
    func selectedButton(title:String,backgroundColors:UIColor, iconName: String, widthConstraints: NSLayoutConstraint){
       self.backgroundColor = backgroundColors
       self.setTitle(title, for: .normal)
       self.setTitle(title, for: .highlighted)
       self.setTitleColor(UIColor.white, for: .normal)
       self.setTitleColor(UIColor.white, for: .highlighted)
       self.setImage(UIImage(named: iconName), for: .normal)
       self.setImage(UIImage(named: iconName), for: .highlighted)
       let imageWidth = self.imageView!.frame.width
       let textWidth = (title as NSString).size(withAttributes:[NSAttributedString.Key.font:self.titleLabel!.font!]).width
       let width = textWidth + imageWidth + 24
       //24 - the sum of your insets from left and right
       widthConstraints.constant = width
       self.layoutIfNeeded()
       }

    
}
#endif

public protocol Flashing {}

extension Flashing where Self:UIButton {
    //闪烁的动画
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }

}


public extension UIButton {

  func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
       self.setImage(image.withRenderingMode(renderMode), for: .normal)
       self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
       self.titleEdgeInsets.left = (self.frame.width/2) - (self.titleLabel?.frame.width ?? 0)
       self.contentHorizontalAlignment = .left
       self.imageView?.contentMode = .scaleAspectFit
   }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
}




public extension UIButton {
    
        func addRightIcon(image: UIImage) {
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false

            addSubview(imageView)

            let length = CGFloat(15)
            if #available(iOS 15.0, *) {
            
            } else {
            titleEdgeInsets.right += length
            }
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 10),
                imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
                imageView.widthAnchor.constraint(equalToConstant: length),
                imageView.heightAnchor.constraint(equalToConstant: length)
            ])
        }
    func addLeftImage(image:UIImage) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        
        let length = CGFloat(15)
        if #available(iOS 15.0, *) {
            titleEdgeInsets.left += length
            
        }else {
            titleEdgeInsets.left += length
        }
        
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: self.titleLabel!.leadingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
    
}
//https://stackoverflow.com/questions/4201959/label-under-image-in-uibutton
public extension UIButton {
    
        
        func centerVertically(padding: CGFloat = 6.0) {
            guard
                let imageViewSize = self.imageView?.frame.size,
                let titleLabelSize = self.titleLabel?.frame.size else {
                return
            }
            
            let totalHeight = imageViewSize.height + titleLabelSize.height + padding
            
            self.imageEdgeInsets = UIEdgeInsets(
                top: -(totalHeight - imageViewSize.height),
                left: 0.0,
                bottom: 0.0,
                right: -titleLabelSize.width
            )
            
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0.0,
                left: -imageViewSize.width,
                bottom: -(totalHeight - titleLabelSize.height),
                right: 0.0
            )
            
            self.contentEdgeInsets = UIEdgeInsets(
                top: 0.0,
                left: 0.0,
                bottom: titleLabelSize.height,
                right: 0.0
            )
        }
        
    }
//MARK:- disable selected highlight
public extension UIButton {
    func disableSelectedHighlight() {
        self.adjustsImageWhenHighlighted = false
    }
}
