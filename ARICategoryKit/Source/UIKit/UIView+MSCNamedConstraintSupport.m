//
//  UIView+MSCNamedConstraintSupport.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "UIView+MSCNamedConstraintSupport.h"
#import "NSObject+MSCNameTag.h"
#import "MSCCommon.h"

@implementation UIView (MSCNamedConstraintSupport)
- (NSLayoutConstraint *)constraintNamed:(NSString *)aName {
    if (!aName) {
        return nil;
    }
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.nameTag && [constraint.nameTag isEqualToString:aName]) {
            return constraint;
        }
        
    }
    if (self.superview) {
        return [self.superview constraintNamed:aName];
    }
    return nil;
}
- (NSLayoutConstraint *)constraintNamed:(NSString *)aName matchingView:(UIView *)theView {
    if(!aName ) return nil;
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.nameTag && [constraint.nameTag isEqualToString:aName]) {
            if(constraint.firstItem == theView) return constraint;
            if (constraint.secondItem && constraint.secondItem == theView) return constraint;
        }
        if (self.superview) return [self.superview constraintNamed:aName matchingView:theView];
    }
    return nil;
}
-(NSArray *)constraintsNamed:(NSString *)aName {
    //for this ,all constraints match a nil item
    if (!aName) return self.constraints;
    //Howerve, constraints have to have a name to match a non-nil name
    NSMutableArray *array = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in self.constraints)
        if (constraint.nameTag && [constraint.nameTag isEqualToString:aName])
            [array addObject:constraint];
           // recurse upwords
    if (self.superview) {
        [array addObjectsFromArray:[self.superview constraintsNamed:aName]];
    }
    return array;
        
    
}

@end


