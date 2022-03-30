//
//  UIViewController+MSCLifecycleMonitor.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "UIViewController+MSCLifecycleMonitor.h"
#import <objc/runtime.h>



@implementation UIViewController (MSCLifecycleMonitor)
+ (void)load {
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(msc_dealloc));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}
- (void)msc_dealloc {
    NSLog(@"%@ released",self);
    [self msc_dealloc];
    
}
@end
