//
//  UIViewController+Common.m
//
//  Created by Marc Zhao on 2022/3/30..
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

+ (UIViewController *)po_rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (UINavigationController *)po_currentNavigationViewController {
    return self.po_currentViewController.navigationController;
}

+ (UIViewController *)po_currentViewController {
    return [self po_currentViewControllerFrom:self.po_rootViewController];
}

+ (UIViewController *)po_currentViewControllerFrom:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self po_currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }
    else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self po_currentViewControllerFrom:tabBarController.selectedViewController];
    }
    else if (viewController.presentedViewController != nil) {
        return [self po_currentViewControllerFrom:viewController.presentedViewController];
    }
    else {
        return viewController;
    }
}

@end
