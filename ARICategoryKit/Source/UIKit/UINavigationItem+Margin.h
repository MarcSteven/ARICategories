//
//  UINavigationItem+Margin.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationItem (Margin)

/**
 左边偏移量
 */
@property (nonatomic, assign) CGFloat po_leftMargin;

/**
 右边偏移量
 */
@property (nonatomic, assign) CGFloat po_rightMargin;

@end

NS_ASSUME_NONNULL_END
