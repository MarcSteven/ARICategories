//
//  UIView+AutoLayoutDebugging.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/3.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "UIView+AutoLayoutDebugging.h"

@implementation UIView (AutoLayoutDebugging)
+(void)leftAlignAndVerticallySpaceOutviews:(NSArray *)views distance:(CGFloat)distance {
    for (NSInteger i = 1;i < views.count ; i ++) {
        UIView *firstView = views[i -1];
        UIView *secondView = views[i];
        firstView.translatesAutoresizingMaskIntoConstraints = NO;
        secondView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeTop multiplier:1 constant:distance];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        [firstView.superview addConstraints:@[constraint1,constraint2]];
        
    }
}
- (void)exerciseAmbiguityInLayoutRepeatedly:(BOOL)recursive {
    #ifdef DEBUG
        if(self.hasAmbiguousLayout) {
            [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(exerciseAmbiguityInLayout) userInfo:nil repeats:YES];
        }
        if(recursive) {
            for(UIView *subview in self.subviews) {
                [subview exerciseAmbiguityInLayoutRepeatedly:YES];
            }
            
        }
    #endif
}
@end
