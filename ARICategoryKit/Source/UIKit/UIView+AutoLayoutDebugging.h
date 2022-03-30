//
//  UIView+AutoLayoutDebugging.h
//  CrossBorderHelp
//
//  Created by Marc Zhao on 2018/7/29.
//  Copyright © 2018年 Shenzhen CrossBorder help Network co,LTD. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AutoLayoutDebugging)

- (void)exerciseAmbiguityInLayoutRepeatedly:(BOOL)recursive;
+ (void) leftAlignAndVerticallySpaceOutviews:(NSArray *)views
                                   distance:(CGFloat)distance;
@end
NS_ASSUME_NONNULL_END
