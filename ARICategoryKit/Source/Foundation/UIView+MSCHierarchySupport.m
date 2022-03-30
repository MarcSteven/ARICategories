//
//  UIView+MSCHierarchySupport.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "UIView+MSCHierarchySupport.h"



@implementation UIView (MSCHierarchySupport)
- (NSArray *)superviews {
    NSMutableArray *array = [NSMutableArray array];
    UIView *view = self.superview;
    while (view) {
        [array addObject:view];
        view = view.superview;
        
    }
    return array;
    
}
- (NSArray *)allSubviews {
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        [array addObject:view];
        [array addObjectsFromArray:[view allSubviews]];
        
    }
    return array;
}
- (BOOL)isAncestorOf:(UIView *)aView {
    return [aView.superviews containsObject:aView];
}
- (UIView *)nearestCommonAncestor:(UIView *)aView {
    //check for the same view
    if (self == aView) {
        return self;
    }
    if ([self isAncestorOf:aView]) {
        return self;
    }
    if ([aView isAncestorOf:self]) {
        return aView;
    }
    //search for indirect common ancestor
    NSArray *ancestors = self.superviews;
    for (UIView *view in aView.superviews) {
        if ([ancestors containsObject:view]) {
            return view;
        }
    }
    return nil;
}
@end

@implementation UIView (ConstraintReadyViews)

+ (instancetype)view {
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
