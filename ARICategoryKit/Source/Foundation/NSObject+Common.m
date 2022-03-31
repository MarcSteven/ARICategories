//
//  NSObject+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSObject+Common.h"

@implementation NSObject (Common)

+ (UIViewController *)po_getWindowViewController {
    
    for (UIWindow *window in [UIApplication sharedApplication].windows.reverseObjectEnumerator) {
        
        UIView *tempView = window.subviews.lastObject;
        
        for (UIView *subview in window.subviews.reverseObjectEnumerator) {
            if ([subview isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
                tempView = subview;
                break;
            }
        }
        
        BOOL(^canNext)(UIResponder *) = ^(UIResponder *responder) {
            if (![responder isKindOfClass:[UIViewController class]]) {
                return YES;
            }
            else if ([responder isKindOfClass:[UINavigationController class]]) {
                return YES;
            }
            else if ([responder isKindOfClass:[UITabBarController class]]) {
                return YES;
            }
            else if ([responder isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
                return YES;
            }
            return NO;
        };
        
        UIResponder *nextResponder = tempView.nextResponder;
        
        while (canNext(nextResponder)) {
            tempView = tempView.subviews.firstObject;
            if (!tempView) {
                return nil;
            }
            nextResponder = tempView.nextResponder;
        }
        
        UIViewController *currentVC = (UIViewController *)nextResponder;
        if (currentVC) {
            return currentVC;
        }
    }
    return nil;
}

+ (UIViewController *)po_getDisplayViewController {
    
    // 定义一个变量存放当前屏幕显示的viewcontroller
    UIViewController *result = nil;
    
    // 得到当前应用程序的主要窗口
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    // windowLevel是在 Z轴 方向上的窗口位置，默认值为UIWindowLevelNormal
    if (window.windowLevel != UIWindowLevelNormal) {
        // 获取应用程序所有的窗口
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            // 找到程序的默认窗口（正在显示的窗口）
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                // 将关键窗口赋值为默认窗口
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获取窗口的当前显示视图
    UIView *frontView = [[window subviews] firstObject];
    
    // 获取视图的下一个响应者，UIView视图调用这个方法的返回值为UIViewController或它的父视图
    id nextResponder = [frontView nextResponder];
    
    // 判断显示视图的下一个响应者是否为一个UIViewController的类对象
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    
    return result;
}

@end
