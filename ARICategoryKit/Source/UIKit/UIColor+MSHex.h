//
//  UIColor+MSHex.h
//  MSKit
//
//  Created by Marc Zhao on 2019/10/24.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (MSHex)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (CGFloat)colorComponentFrom:(NSString*)string
                        start:(NSUInteger)start
                       length:(NSUInteger) length;

@end

NS_ASSUME_NONNULL_END
