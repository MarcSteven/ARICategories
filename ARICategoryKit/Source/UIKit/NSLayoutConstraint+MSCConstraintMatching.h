//
//  NSLayoutConstraint+MSCConstraintMatching.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//



#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (MSCConstraintMatching)
- (BOOL) isEqualToLayoutConstraint: (NSLayoutConstraint *) constraint;
- (BOOL) isEqualToLayoutConstraintConsideringPriority: (NSLayoutConstraint *) constraint;
- (BOOL) refersToView: (UIView *) aView;
@property (nonatomic, readonly) BOOL isHorizontal;
@end

NS_ASSUME_NONNULL_END
