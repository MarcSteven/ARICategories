//
//  UILabel+Extension.swift
//  MemoryChainKit
//
//  Created by Marc Zhao on 2019/2/16.
//  Copyright © 2019 Memory Chain technology(China) co,LTD. All rights reserved.
//
import UIKit
public extension UILabel {
     static func build(block:((UILabel)->Void)) ->UILabel {
        let label = UILabel(frame: .zero)
        block(label)
        return label
    }
}


public extension UILabel {
    func underLine() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: textString.count))
            self.attributedText = attributedString
        }
    }
   
    func setAttributeColor(_ color: UIColor, _ string: String) {
        let text = self.text!
        if (text.isEmpty || !text.contains(text)) {
            return
        }
        let attrstring: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
        let str = NSString(string: text)
        let theRange = str.range(of: string)
        // 颜色处理
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:color, range: theRange)
        self.attributedText = attrstring
    }
    
    func addTapGesture(_ target: Any, _ action: Selector) {
        self.isUserInteractionEnabled = true
        let labelTapGestureRecognizer = UITapGestureRecognizer.init(target: target, action: action)
        self.addGestureRecognizer(labelTapGestureRecognizer)
    }
    
    func insertImage(image: UIImage, index: Int) {
        let markAttribute = NSMutableAttributedString(string:self.text!)
        //以上是富文本显示
        let markattch = NSTextAttachment() //定义一个attachment
        markattch.image = image//初始化图片
        markattch.bounds = CGRect(x: 0, y: 0, width: 9, height: 9) //初始化图片的 bounds
        let markattchStr = NSAttributedString(attachment: markattch) // 将attachment  加入富文本中
        markAttribute.insert(markattchStr, at: index)// 将markattchStr  加入原有文字的某个位置
        self.attributedText = markAttribute
    }
}
public extension UILabel {
    func addDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }

    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.addDropShadow()
        return label
    }
}

public extension UILabel {
   func desiredSize() -> CGSize {
       // Bound the expected size
       let maximumLabelSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
       // Calculate the expected size
       var expectedLabelSize = self.sizeThatFits(maximumLabelSize)
       
       #if os(tvOS)
           // Sanitize width to 16384.0 (largest width a UILabel will draw on tvOS)
           expectedLabelSize.width = min(expectedLabelSize.width, 16384.0)
       #else
           // Sanitize width to 5461.0 (largest width a UILabel will draw on an iPhone 6S Plus)
           expectedLabelSize.width = min(expectedLabelSize.width, 5461.0)
       #endif

       // Adjust to own height (make text baseline match normal label)
       expectedLabelSize.height = bounds.size.height
       return expectedLabelSize
   }
}


public extension UILabel {
    static func sizeFor(content: NSString, font: UIFont) -> CGSize {
            let text: NSString = content
          
            #if swift(>=4.2)
            let textSize = text.size(withAttributes: [NSAttributedString.Key.font : font])
            #else
            let textSize = text.size(withAttributes: [NSAttributedStringKey.font : font])
            #endif
          
            return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
        }

}


public extension UILabel {
    
    
    var letterSpacing: CGFloat? {
            get { getAttribute(.kern) }
            set { setAttribute(.kern, value: newValue) }
        }
}


fileprivate extension UILabel {

/// Attributes of `attributedText` (if any).
    var attributes: [NSAttributedString.Key: Any]? {
        get {
            if let attributedText = attributedText,
               attributedText.length > 0 {
                return attributedText.attributes(at: 0, effectiveRange: nil)
            } else {
                return nil
            }
        }
    }
    
    /// Get attribute for the given key (if any).
    func getAttribute<AttributeType>(
        _ key: NSAttributedString.Key
    ) -> AttributeType? where AttributeType: Any {
        return attributes?[key] as? AttributeType
    }
    
    
}
fileprivate extension UILabel {
    
    
    func getAttribute<AttributeType>(
            _ key: NSAttributedString.Key
        ) -> AttributeType? where AttributeType: OptionSet {
            if let attribute = attributes?[key] as? AttributeType.RawValue {
                return .init(rawValue: attribute)
            } else {
                return nil
            }
        }
        /// Add (or remove) `OptionSet` attribute for the given key (if any).
         func setAttribute<AttributeType>(
            _ key: NSAttributedString.Key,
            value: AttributeType?
        ) where AttributeType: OptionSet  {
            if let value = value {
                addAttribute(key, value: value.rawValue)
            } else {
                removeAttribute(key)
            }
        }
}


fileprivate extension UILabel {
    func addAttribute(_ key: NSAttributedString.Key, value: Any) {
            attributedText = attributedText?.stringByAddingAttribute(key, value: value)
        }
        
        func removeAttribute(_ key: NSAttributedString.Key) {
            attributedText = attributedText?.stringByRemovingAttribute(key)
        }
        func setAttribute<AttributeType>(
            _ key: NSAttributedString.Key,
            value: AttributeType?
        ) where AttributeType: Any  {
            if let value = value {
                addAttribute(key, value: value)
            } else {
                removeAttribute(key)
            }
        }
}

fileprivate extension NSAttributedString {
    
    var entireRange: NSRange {
        NSRange(location: 0, length: self.length)
    }
    
    func stringByAddingAttribute(_ key: NSAttributedString.Key, value: Any) -> NSAttributedString {
        let changedString = NSMutableAttributedString(attributedString: self)
        changedString.addAttribute(key, value: value, range: self.entireRange)
        return changedString
    }
    
    func stringByRemovingAttribute(_ key: NSAttributedString.Key) -> NSAttributedString {
        let changedString = NSMutableAttributedString(attributedString: self)
        changedString.removeAttribute(key, range: self.entireRange)
        return changedString
    }
}

public extension UILabel {
    var mc_hasText:Bool {
        guard let text = text else {
            return false
        }
        return text.mc_hasText
    }
    @objc var mc_hasNonWhitespaceText:Bool {
        guard let text = text else {
            return false
        }
        return text.mc_hasNonWhitespaceText
    }
    var mc_hasAttributedText:Bool {
        guard let attributedText = attributedText else {
            return false
        }
        return attributedText.mc_hasText
    }
    var mc_hasNonWhiteSpaceAttributedText:Bool {
        guard let attributedText = attributedText else {
            return false
        }
        return attributedText.mc_hasNonWhitespaceText
    }
    var mc_hasAnyText:Bool {
        return mc_hasText || mc_hasAttributedText
    }
    var mc_hasAnyNonWhitespaceText:Bool {
        return mc_hasNonWhitespaceText || mc_hasNonWhiteSpaceAttributedText
    }
}
