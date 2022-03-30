//
//  UIColor+HexString.h
//  
//
//  Created by Marc Zhao on 2020/1/14.
//

#import <UIKit/UIKit.h>




NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HexString)
+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end

NS_ASSUME_NONNULL_END
