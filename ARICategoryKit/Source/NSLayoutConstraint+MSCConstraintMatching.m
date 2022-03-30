//
//  NSLayoutConstraint+MSCConstraintMatching.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "NSLayoutConstraint+MSCConstraintMatching.h"
#import "MSCCommon.h"



@implementation NSLayoutConstraint (MSCConstraintMatching)
- (BOOL)isEqualToLayoutConstraint:(NSLayoutConstraint *)constraint {
    if (![self.class isEqual:[NSLayoutConstraint class]]) {
        return NO;
    }
    if (![self.class isEqual:constraint.class]) {
        return NO;
    }
    if (self.firstItem != constraint.firstItem) {
        return NO;
    }
    if (self.secondItem != constraint.secondItem) {
        return NO;
    }
    if (self.firstAttribute != constraint.firstAttribute) {
        return NO;
    }
    if (self.secondAttribute != constraint.secondAttribute) {
        return NO;
    }
    if (self.relation != constraint.relation) {
        return NO;
    }
    if (self.multiplier != constraint.multiplier) {
        return NO;
    }
    if (self.constant != constraint.constant) {
        return NO;
    }
    return YES;
}
- (BOOL)isEqualToLayoutConstraintConsideringPriority:(NSLayoutConstraint *)constraint {
    if (![self isEqualToLayoutConstraint:constraint]) {
        return NO;
    }
    return (self.priority == constraint.priority);
}
- (BOOL)refersToView:(UIView *)aView {
    if (!aView) {
        return NO;
    }
    if (!self.firstItem) {
        return NO;
    }
    if (self.firstItem == aView) {
        return YES;
    }
    if (!self.secondItem) {
        return NO;
    }
    return (self.secondItem == aView);
    
}
- (BOOL)isHorizontal {
    return IS_HORIZONTAL_ALIGNMENT(self.firstAttribute);
}
@end
