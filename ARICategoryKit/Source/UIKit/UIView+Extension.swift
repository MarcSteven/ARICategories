//
//  UIView+Extension.swift
//  MemoryChain
//
//  Created by Marc Zhao on 2018/8/5.
//  Copyright © 2018年 Memory Chain technology(China) co,LTD. All rights reserved.
//
import UIKit

public extension UIView {
    func subviews<T:UIView>(ofType whatType:T.Type,
                            recursing:Bool = true) ->[T] {
        var result = self.subviews.compactMap{$0 as? T}
        guard recursing else {
            return result
        }
        for sub in self.subviews {
            result.append(contentsOf:sub.subviews(ofType: whatType))
        }
        return result
    }
    
    
}
public extension UIView {
    func constraint(withIdentifier id:String) ->NSLayoutConstraint? {
        return self.constraints.first {$0.identifier == id } ?? self.superview?.constraint(withIdentifier: id)
    }
}

@objc extension UIView {
   public  func reportAmbiguity(filter:Bool = false) {
        let has = self.hasAmbiguousLayout
        if has || !filter {
            print(self,has)
        }
        for sub in self.subviews {
            sub.reportAmbiguity(filter: filter)
        }
    }
}

public extension UIView {
    func parentView<T:UIView>(of type:T.Type) ->T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }

}

/// MARK: - window frame

public extension UIView {
    var windowFrame:CGRect? {
        return superview?.convert(frame, to: nil)
    }
}
//MARK: - add constraints
public extension UIView {
    func addConstraints(format: String, options: NSLayoutConstraint.FormatOptions = [], metrics: [String: AnyObject]? = nil, views: [String: UIView]) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views))
    }
    
    func addUniversalConstraints(format: String, options: NSLayoutConstraint.FormatOptions = [], metrics: [String: AnyObject]? = nil, views: [String: UIView]) {
        addConstraints(format: "H:\(format)", options: options, metrics: metrics, views: views)
        addConstraints(format: "V:\(format)", options: options, metrics: metrics, views: views)
    }
}

public extension UIView {
    func setCorner(_ radius:CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func setCircleCorner() {
        superview?.layoutIfNeeded()
        setCorner(frame.height / 2)
    }
    func setBorder(width:CGFloat,color:UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
}
//MARK: - blur
extension UIView {
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}

public typealias GradientPoints = (startPoint:CGPoint,endPoint:CGPoint)
//Gradient orientation
public enum GradientOrientation {
    case topRightToBottomLeft,topLeftToBottomRight,horizontal,vertical
    var startPoint:CGPoint {
        return points.startPoint
    }
    var endPoint:CGPoint {
        return points.endPoint
    }
    var points:GradientPoints {
        get {
            switch self {
            case .topRightToBottomLeft:
                return (CGPoint(x: 0.0, y: 1.0),CGPoint(x: 1.0, y: 0.0))
            case .topLeftToBottomRight:
                return (CGPoint(x: 0.0, y: 0.0),CGPoint(x: 1, y: 1))
            case .horizontal:
                return (CGPoint(x: 0.0, y: 0.5),CGPoint(x: 1.0, y: 0.5))
            case .vertical:
                return (CGPoint(x: 0.0, y: 0.0),CGPoint(x: 0.0, y: 1.0))
           
            }
        }
    }
}
//MARK: - configure gradient to the view
public extension UIView {
    
    func configureGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func configureGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation)  {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
}
public extension UIView {
    func move(to destination:CGPoint,duration:TimeInterval,
              options:UIView.AnimationOptions) {
        UIView.animate(withDuration:duration,delay:0,options:options,animations:{
            self.center = destination
        },completion:nil)
    }
    func rotate360Degrees(duration:TimeInterval = 1.0,
                          completionDelegate:AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = duration
        if let delegate:AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
    func rotate180(duration: TimeInterval, options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.transform = self.transform.rotated(by: CGFloat.pi)
        }, completion: nil)
    }
    func addSubviewWithZoomInAnimation(_ view: UIView, duration: TimeInterval,
                                       options: UIView.AnimationOptions) {
        // 1
        view.transform = view.transform.scaledBy(x: 0.01, y: 0.01)
        
        // 2
        addSubview(view)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            // 3
            view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    func removeWithZoomOutAnimation(duration: TimeInterval,
                                    options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            // 1
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { _ in
            // 2
            self.removeFromSuperview()
        })
    }
    func addSubviewWithFadeAnimation(_ view: UIView, duration: TimeInterval, options: UIView.AnimationOptions) {
        // 1
        view.alpha = 0.0
        // 2
        addSubview(view)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            // 3
            view.alpha = 1.0
        }, completion: nil)
    }
    func changeColor(to color: UIColor, duration: TimeInterval,
                     options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.backgroundColor = color
        }, completion: nil)
    }
    @objc func removeWithSinkAnimationRotateTimer(timer: Timer) {
        // 1
        let newTransform = transform.scaledBy(x: 0.9, y: 0.9)
        // 2
        transform = newTransform.rotated(by: 0.314)
        // 3
        alpha *= 0.98
        // 4
        tag -= 1;
        // 5
        if tag <= 0 {
            timer.invalidate()
            removeFromSuperview()
        }
    }
}
public extension UIView.AnimationCurve {
    var title:String {
        switch self {
        case .easeIn:
            return "Ease in"
        case .easeOut:
            return "Ease out"
        case .easeInOut:
            return "Ease In Out"
        case .linear:
            return "Linear"
        
        @unknown default:
            fatalError()
        }
    }
    //convert this curve into it's correspoing uiviewAniamtionOptions value for use in Animations
    var animationOptions:UIView.AnimationOptions {
        switch self {
        case .easeIn:
            return .curveEaseIn
        case .easeInOut:
            return .curveEaseInOut
        case .linear:
            return .curveLinear
        case .easeOut:
            return .curveEaseOut
        @unknown default:
            fatalError()
        }
    }
}
extension UIView  {
open func printDebugSubviewsDescription() {
    debugSubviews()
}

private func debugSubviews(_ count: Int = 0) {
    if count == 0 {
        print("\n\n\n")
    }

    for _ in 0...count {
        print("--")
    }

    print("\(type(of: self))")

    for view in subviews {
        view.debugSubviews(count + 1)
    }

    if count == 0 {
        print("\n\n\n")
    }
}
}

 // add shadow
public extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float)
        {
            layer.masksToBounds = false
            layer.shadowOffset = offset
            layer.shadowColor = color.cgColor
            layer.shadowRadius = radius
            layer.shadowOpacity = opacity

            let backgroundCGColor = backgroundColor?.cgColor
            backgroundColor = nil
            layer.backgroundColor =  backgroundCGColor
        }
    
    
}

//add rounder corner shadow
public extension UIView {
    
    func addRoundedCorner(_ targetView:UIView?) {
        
        
            targetView!.layer.cornerRadius = 5.0;
            targetView!.layer.masksToBounds = true

            //UIView Set up boarder
            targetView!.layer.borderColor = UIColor.yellow.cgColor;
            targetView!.layer.borderWidth = 3.0;

            //UIView Drop shadow
            targetView!.layer.shadowColor = UIColor.darkGray.cgColor;
            targetView!.layer.shadowOffset = CGSize(width: 2, height: 2)
            targetView!.layer.shadowOpacity = 1.0
    }
    
}
// add gradient background for UIView
public extension UIView {
    func applyGradient(colours: [UIColor])  {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.addSublayer(gradient)
    }
}

// corner radius
public extension UIView {
    var cornerRadius:CGFloat {
           get {
               return layer.cornerRadius
           }
           set {
               layer.cornerRadius = newValue
               layer.masksToBounds  = newValue > 0
           }
       }
}

// Conform to `Animatable` protocol to animate views.
public protocol Animatable: AnyObject {}

// MARK: - Default implementation for UIView.
public extension Animatable where Self: UIView {
    
    /// Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds _(default is 1.0 second)_.
    ///   - delay: animation delay in seconds _(default is 0.0 second)_.
    ///   - completion: optional completion handler to run with animation finishes _(default is nil)_.
    func fadeIn(withDuration duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: { [unowned self] in
            self.alpha = 1.0
            }, completion: completion)
        
        
    }
    
    /// Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds _(default is 1.0 second)_.
    ///   - delay: animation delay in seconds _(default is 0.0 second)_.
    ///   - completion: optional completion handler to run with animation finishes _(default is nil)_.
    func fadeOut(withDuration duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: { [unowned self] in
            self.alpha = 0.0
            }, completion: completion)
    }
    
    /// Pop in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds _(default is 0.25 second)_.
    ///   - delay: animation delay in seconds _(default is 0.0 second)_.
    ///   - completion: optional completion handler to run with animation finishes _(default is nil)_.
    func popIn(withDuration duration: TimeInterval = 0.25, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: { [unowned self] in
            self.transform = .init(scaleX: 0.95, y: 0.95)
            }, completion: completion)
    }
    
    /// Pop out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds _(default is 0.25 second)_.
    ///   - delay: animation delay in seconds _(default is 0.0 second)_.
    ///   - completion: optional completion handler to run with animation finishes _(default is nil)_.
    func popOut(withDuration duration: TimeInterval = 0.25, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: { [unowned self] in
            self.transform = .identity
            }, completion: completion)
    }
    
    /// Shake view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds _(default is 1.0 second)_.
    ///   - delay: animation delay in seconds _(default is 0.0 second)_.
    ///   - completion: optional completion handler to run with animation finishes _(default is nil)_.
    func shake(withDuration duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            CATransaction.begin()
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            CATransaction.setCompletionBlock(completion)
            animation.duration = duration
            animation.values = [-15.0, 15.0, -12.0, 12.0, -8.0, 8.0, -3.0, 3.0, 0.0]
            self.layer.add(animation, forKey: "shake")
            CATransaction.commit()
        }
    }
    
}

public protocol ZoomIn {}

extension ZoomIn where Self:UIView {
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     - parameter duration: animation duration
     */
     func zoomIn(duration: TimeInterval = 0.2) {
         self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
         UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
             self.transform = CGAffineTransform.identity
            }) { (animationCompleted: Bool) -> Void in
        }
    }
    /**
     Zoom in any view with specified offset magnification.
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
     func zoomInWithEasing( duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
     UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
         self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
            }, completion: { (completed: Bool) -> Void in
             UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                 self.transform = CGAffineTransform.identity
                    }, completion: { (completed: Bool) -> Void in
                })
        })
    }



}

public protocol ZoomOut {}


extension ZoomOut where Self:UIView {
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     - parameter duration: animation duration
     */
     func zoomOut(duration: TimeInterval = 0.2) {
     self.transform = CGAffineTransform.identity
     UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
         self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }) { (animationCompleted: Bool) -> Void in
        }
    }

    
    /**
     Zoom out any view with specified offset magnification.
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomOutWithEasing( duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
     UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
         self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
            }, completion: { (completed: Bool) -> Void in
             UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                 self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                    }, completion: { (completed: Bool) -> Void in
                })
        })
    }

}



public extension UIView {
    
    func centerHorizontally(parent: UIView) {
           let center = parent.convert(parent.center, from: parent.superview)
           self.center = CGPoint(x: center.x, y: self.center.y)
       }
       
       func centerVertically(parent: UIView) {
           let center = parent.convert(parent.center, from: parent.superview)
           self.center = CGPoint(x: self.center.x, y: center.y)
       }
}


/// Conform to `Shadowable` protocol to set shadow related propertoes for views.
public protocol Shadowable: AnyObject {}

// MARK: - Default implementation for UIView.
public extension Shadowable where Self: UIView {
    
    /// Shadow color of view.
    var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.masksToBounds = false
            layer.shadowColor = newValue?.cgColor
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /// Shadow offset of view.
     var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /// Shadow opacity of view.
     var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /// Shadow radius of view.
     var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    /// Set view's shadow
    ///
    /// - Parameters:
    ///   - color: Shadow color of view.
    ///   - offset: Shadow offset of view.
    ///   - opacity: Shadow opacity of view.
    ///   - radius: Shadow radius of view.
     func setShadow(color: UIColor?, offset: CGSize, opacity: Float, radius: CGFloat) {
        shadowColor = color
        shadowOffset = offset
        shadowOpacity = opacity
        shadowRadius = radius
    }
    
}

//MARK: - add method to draw dotted line for UIView
public extension UIView {
    func drawDottedLine(width: CGFloat, color: CGColor) {
          let caShapeLayer = CAShapeLayer()
          caShapeLayer.strokeColor = color
          caShapeLayer.lineWidth = width
          caShapeLayer.lineDashPattern = [2,3]
          let cgPath = CGMutablePath()
          let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
          cgPath.addLines(between: cgPoint)
          caShapeLayer.path = cgPath
          layer.addSublayer(caShapeLayer)
       }
}


