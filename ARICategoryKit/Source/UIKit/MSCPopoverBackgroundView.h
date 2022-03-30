//
//  MSCPopoverBackgroundView.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/10.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSCPopoverBackgroundView : UIPopoverBackgroundView

+ (void)setBackgroundColor:(UIColor *)backgroundColor;
+ (void)setCornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
