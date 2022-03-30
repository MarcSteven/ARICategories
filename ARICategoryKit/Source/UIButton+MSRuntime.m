//
//  UIButton+MSRuntime.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/13.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "UIButton+MSRuntime.h"

#import <Objc/runtime.h>

const void * MSRoundTouchEnableKey = & MSRoundTouchEnableKey;


@implementation UIButton (MSRuntime)
+ (void)initialize {
    [super initialize];
    Method replacedMethod = class_getInstanceMethod([self class], @selector(replacePointInside:withEvent:));
    Method originMethod = class_getInstanceMethod([self class], @selector(pointInside:withEvent:));
    method_setImplementation(originMethod, method_getImplementation(replacedMethod));
    
}
- (BOOL)roundTouchEnable {
    return [objc_getAssociatedObject(self, MSRoundTouchEnableKey) boolValue];
    
}
- (void)setRoundTouchEnable:(BOOL)roundTouchEnable {
    objc_setAssociatedObject(self, MSRoundTouchEnableKey, @(roundTouchEnable), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)replacePointInside:(CGPoint)point
                 withEvent:(UIEvent *)event {
    if (CGRectGetWidth(self.frame) != CGRectGetHeight(self.frame) || !self.roundTouchEnable) {
        return [super pointInside:point withEvent:event];
    }
    CGFloat radius = CGRectGetWidth(self.frame) / 2;
    CGPoint offset = CGPointMake(point.x - radius, point.y - radius);
    return sqrt(offset.x * offset.x + offset.y * offset.y) <= radius;
}
@end
