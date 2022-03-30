//
//  NSURL+Exception.m
//  MemoryChainKit
//
//  Created by Marc Steven on 2020/4/29.
//  Copyright © 2020 Marc Steven(https://github.com/MarcSteven). All rights reserved.
//

#import "NSURL+Exception.h"
#import <objc/runtime.h>
@implementation NSURL (Exception)
+ (void)load {
    //static dispatch_once_t onceToken;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(URLWithString:);
        SEL swizzleSelector = @selector(ms_initWithString:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzleSelector);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
+ (instancetype)ms_initWithString:(NSString *)string {
    NSURL *url = [NSURL ms_initWithString:string];
    if (url == nil) {
        NSLog(@"empty url");
    }
    return url;
}
@end
