//
//  UIView+MSCConstraintMatching.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "UIView+MSCConstraintMatching.h"

#import <AppKit/AppKit.h>


@implementation UIView (MSCConstraintMatching)
//- (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint {
//    NSArray *views = [@[self] arrayByAddingObjectsFromArray:self.superviews];
//    for (VIEW_CLASS *view in views) {
//        for (NSLayoutConstraint *constraint in view.constraints) {
//            if ([constraint isEqual:aConstraint]) {
//                return constraint;
//            }
//        }
//    }
//    return nil;
//}
- (NSArray *)allConstraints {
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.constraints];
    for (VIEW_CLASS *view in self.subviews) {
        [array addObjectsFromArray:[view allConstraints]];
    }
    return array;
}
//- (NSArray *)referencingConstraintsInSuperViews {
//    NSMutableArray *array = [NSMutableArray array];
//    for (VIEW_CLASS *view in self.superviews) {
//        for (NSLayoutConstraint *constraint in view.constraints) {
//            if (![constraint.class isEqual:[NSLayoutConstraint class]]) {
//                continue;
//                if([constraint ])
//            }
//        }
//    }
//}
@end
