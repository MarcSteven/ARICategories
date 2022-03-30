//
//  UIButton+MSTouch.m
//  MSKit
//
//  Created by Marc Zhao on 2019/10/24.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "UIButton+MSTouch.h"
#import <objc/runtime.h>
@implementation UIButton (MSTouch)
- (BOOL)isTouchInside {
    self.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.enabled = YES;
    });
    return YES;
}
- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, _cmd)doubleValue];
}
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
//runtime to dynamitic to bind the property
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, _cmd)boolValue];
    
}
- (void)resetState {
    [self setIsIgnoreEvent:NO];
    
}
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL origialSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(msc_sendAction:to:forEvent:);
        Method originalMethod = class_getInstanceMethod(self, origialSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        BOOL isAdd = class_addMethod(self, origialSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (isAdd) {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
- (void)msc_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([self isKindOfClass:[UIButton class]]) {
        self.timeInterval = self.timeInterval == 0 ? defaultInterval : self.timeInterval;
        if (self.isIgnoreEvent) {
            return;
        }else if (self.timeInterval > 0) {
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        }
        
    }
    self.isIgnoreEvent = YES;
    [self msc_sendAction:action to:target forEvent:event];
    
}
@end
