//
//  UIImage+Extension.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/10.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)buttonImageWithColor:(UIColor *)color
                     cornerRadius:(CGFloat)cornerRadius
                      shadowColor:(UIColor *)shadowColor
                     shadowInsets:(UIEdgeInsets)shadowInset;
- (UIImage *)imageWithMiniumSize:(CGSize)size;
+ (UIImage *)stepperPlusImageWithColor:(UIColor *)color;
+ (UIImage *)stepperMinusImageWithColor:(UIColor *)color;
+ (UIImage *)backgroundButtonImageWithColor:(UIColor *)backgroundColor
                                 barMetrics:(UIBarMetrics)metrics
                               cornerRadius:(CGFloat)cornerRadius;
@end



@interface UIImage (scale)
#pragma mark - UIImage scale method to deal with the related image
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage*)cropToRect:(CGRect)rect;
- (UIImage *) resampleWidth:(CGFloat) w;
- (UIImage *) resampleHeight:(CGFloat) h;
- (UIImage *) resampleCropCenter:(CGSize ) size;

@end

NS_ASSUME_NONNULL_END
