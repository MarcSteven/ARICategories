//
//  UIViewController+Common.h
//
//  Created by Marc Zhao on 2022/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Common)

/**
 获取当前主控制器
 */
+ (UIViewController *)po_rootViewController;

/**
 获取当前导航栏
 */
+ (UINavigationController *)po_currentNavigationViewController;

/**
 获取当前显示控制器
 */
+ (UIViewController *)po_currentViewController;

@end

NS_ASSUME_NONNULL_END
