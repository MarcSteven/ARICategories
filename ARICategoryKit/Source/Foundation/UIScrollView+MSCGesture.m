//
//  UIScrollView+MSCGesture.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/27.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "UIScrollView+MSCGesture.h"


#import <objc/runtime.h>



@implementation UIScrollView (MSCGesture)

static char kAssociatedObjectKey_gestrueHandleDisable;
- (void)setMsc_gestureHandleDisable:(BOOL)msc_gestureHandleDisable {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_gestrueHandleDisable, @(msc_gestureHandleDisable), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)msc_gestureHandleDisable {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_gestrueHandleDisable) boolValue];
}
#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.msc_gestureHandleDisable) {
        return YES;
    }
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}
- (BOOL)panBack:(UIGestureRecognizer *)gesture {
    if (gesture == self.panGestureRecognizer) {
        CGPoint point = [self.panGestureRecognizer translationInView:self];
        UIGestureRecognizerState state =  gesture.state;
        CGFloat locationDistance = [UIScreen mainScreen].bounds.size.width;
        if (state == UIGestureRecognizerStateBegan || UIGestureRecognizerStatePossible) {
            CGPoint location = [gesture locationInView:self];
            if (point.x > 0 && location.x < locationDistance && self.contentOffset.x < 0 ) {
                return YES;
            }
        }
    }
    return NO;
}
@end
