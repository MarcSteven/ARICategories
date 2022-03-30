//
//  NSUserDefaults+Timing.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/3.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "NSUserDefaults+Timing.h"
#import <objc/runtime.h>


@implementation NSUserDefaults (Timing)
- (BOOL)swizzleSync {
    NSDate *startDate;
    BOOL returnValue;
    startDate = [NSDate date];
    returnValue = NO;
    
    return returnValue;
}

+ (void)load {
    Method original,swizzed;
    original = class_getInstanceMethod(self, @selector(synchronize));
    swizzed = class_getInstanceMethod(self, @selector(swizzleSync));
    method_exchangeImplementations(original, swizzed);
    
}
@end
