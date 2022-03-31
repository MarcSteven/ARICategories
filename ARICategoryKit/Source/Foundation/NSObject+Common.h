//
//  NSObject+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Common)

/**
 获取当前应用展示的控制器
 */
+ (UIViewController *)po_getWindowViewController;

/**
 获取当前应用展示的控制器 ps：非window调用
 */
+ (UIViewController *)po_getDisplayViewController;

@end

NS_ASSUME_NONNULL_END
