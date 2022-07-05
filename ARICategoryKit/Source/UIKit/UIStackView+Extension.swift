//
//  UIStackView+Extension.swift
//  MemoryChain
//
//  Created by Marc Zhao on 2018/8/5.
//  Copyright © 2018年 Memory Chain technology(China) co,LTD. All rights reserved.
//

#if canImport(UIKit)
import UIKit

#if !os(watchOS)
// MARK: - Initializers
@available(iOS 9.0, *)
public extension UIStackView {
    
    ///  Initialize an UIStackView with an array of UIView and common parameters.
    ///
    ///     let stackView = UIStackView(arrangedSubviews: [UIView(), UIView()], axis: .vertical)
    ///
    /// - Parameters:
    ///   - arrangedSubviews: The UIViews to add to the stack.
    ///   - axis: The axis along which the arranged views are laid out.
    ///   - spacing: The distance in points between the adjacent edges of the stack view’s arranged views.(default: 0.0)
    ///   - alignment: The alignment of the arranged subviews perpendicular to the stack view’s axis. (default: .fill)
    ///   - distribution: The distribution of the arranged views along the stack view’s axis.(default: .fill)
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0.0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    convenience init(axis:NSLayoutConstraint.Axis = .vertical,
                     distribution:UIStackView.Distribution = .fill,
                     alignment:UIStackView.Alignment = .fill,
                     space:CGFloat = 0,
                     subviews:[UIView] = []) {
        self.init(arrangedSubviews: subviews)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
}

   public extension UIStackView {
        /// Adds the list of views to the end of the `arrangedSubviews` array.
        ///
        /// - Parameter subviews: The views to be added to the array of views arranged
        ///                       by the stack view.
         func addArrangedSubviews(_ subviews: [UIView]) {
            subviews.forEach {
                addArrangedSubview($0)
            }
        }
    }

    public extension UIStackView {
         func removeAllArrangedSubviews() {
            arrangedSubviews.forEach {
                $0.removeFromSuperview()
            }
        }
    }


   public extension UIStackView {
    func configure(withAxis axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, spacing: CGFloat, distribution: UIStackView.Distribution = .fill) {
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        self.distribution = distribution
  }
} 

#endif
#endif



private let stackViewBackgroundViewTag: Int = 1


public extension UIStackView {

    func ari_addArrangedSubviewsToStackView() -> (([UIView], UIStackView) -> UIStackView) {
      return { subviews, stackView in
        subviews.forEach(stackView.addArrangedSubview)

        return stackView
      }
    }

    @available(iOS 11.0, *)
     func ari_setCustomSpacing(_ spacing: CGFloat) -> ((UIView, UIStackView) -> UIStackView) {
      return { view, stackView in
        stackView.setCustomSpacing(spacing, after: view)

        return stackView
      }
    }

     func ari_setBackgroundColor(_ color: UIColor) -> ((UIStackView) -> (UIStackView)) {
      return { stackView in
        if let firstSubview = stackView.subviews.first, firstSubview.tag == stackViewBackgroundViewTag {
          firstSubview.backgroundColor = color

          return stackView
        }

        let backgroundView = UIView(frame: stackView.bounds)
        backgroundView.tag = stackViewBackgroundViewTag
        backgroundView.backgroundColor = color
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.insertSubview(backgroundView, at: 0)

        return stackView
      }
    }


}

