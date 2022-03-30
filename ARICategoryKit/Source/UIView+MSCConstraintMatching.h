//
//  UIView+MSCConstraintMatching.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "MSCCommon.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MSCConstraintMatching)
@property (nonatomic,readonly) NSArray *allConstraints;
@property (nonatomic,readonly) NSArray *referencingConstraintsInSuperViews;
@property (nonatomic,readonly) NSArray * referencingConstraints;

// Retrieving constraints
- (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint;
- (NSArray *)constraintsMatchingConstraints:(NSArray *)constraints;
- (NSArray *)constraintsReferencingView:(UIView *)view;

// Removing matching constraints
- (void) removeMatchingConstraint: (NSLayoutConstraint *) aConstraint;
- (void) removeMatchingConstraints: (NSArray *) anArray;

// Removing named constraints
- (void) removeConstraintsNamed: (NSString *) name;
- (void) removeConstraintsNamed: (NSString *) name matchingView: (VIEW_CLASS *) view;
@end

NS_ASSUME_NONNULL_END
