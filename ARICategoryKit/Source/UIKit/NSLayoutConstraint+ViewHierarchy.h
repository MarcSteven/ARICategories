//
//  NSLayoutConstraint+ViewHierarchy.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/26.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (ViewHierarchy)
/**
 
 property
 */
@property (nonatomic,readonly) UIView *firstView;
@property (nonatomic,readonly) UIView *secondView;
@property (nonatomic,readonly) BOOL isUnary;
@property (nonatomic,readonly) UIView *likelyOwner;

@end

NS_ASSUME_NONNULL_END
