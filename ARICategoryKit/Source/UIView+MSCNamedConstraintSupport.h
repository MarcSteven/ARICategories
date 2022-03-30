//
//  UIView+MSCNamedConstraintSupport.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//



#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIView (MSCNamedConstraintSupport)
- (NSLayoutConstraint *)constraintNamed:(NSString *)aName;
- (NSLayoutConstraint *)constraintNamed:(NSString *)aName
                           matchingView:(UIView *)theView;
/**
 returns all matching constraints
 */
-(NSArray *)constraintsNamed:(NSString *)aName;
@end
@interface UIView (MSCConstraintMatching)
- (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint;
- (NSArray *)allConstraints;


@end
NS_ASSUME_NONNULL_END
