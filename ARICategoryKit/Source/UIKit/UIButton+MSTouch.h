//
//  UIButton+MSTouch.h
//  MSKit
//
//  Created by Marc Zhao on 2019/10/24.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//




#import <UIKit/UIKit.h>

#define defaultInterval 1.0 // default time interval

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (MSTouch)
@property (nonatomic,assign) BOOL isIgnoreEvent;

/*
 * override the method to make the button become the unclickable statue between 0.2S
 */
-(BOOL)isTouchInside;
-(NSTimeInterval)timeInterval;
- (void)setTimeInterval:(NSTimeInterval)timeInterval;
@end

NS_ASSUME_NONNULL_END
