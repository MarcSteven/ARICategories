//
//  UIViewController+Tracking.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/4.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "UIViewController+Tracking.h"

#import <objc/runtime.h>

@implementation UIViewController (Tracking)
+ (void)load {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(mx_viewWillAppear:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledMethod);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledMethod, method_getTypeEncoding(originalMethod), method_getTypeEncoding(originalMethod));
            
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
- (void)mx_viewWillAppear:(BOOL)animated {
    [self mx_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@",self);
}
@end
