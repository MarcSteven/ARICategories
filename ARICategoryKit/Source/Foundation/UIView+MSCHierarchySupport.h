//
//  UIView+MSCHierarchySupport.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//




#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIView (MSCHierarchySupport)
@property (nonatomic,readonly) NSArray *superviews;
@property (nonatomic,readonly) NSArray *allSubviews;
- (BOOL)isAncestorOf:(UIView *)aView;
- (UIView *)nearestCommonAncestor:(UIView *)aView;


@end
@interface UIView (ConstraintReadyViews)
+ (instancetype)view;

@end

NS_ASSUME_NONNULL_END
