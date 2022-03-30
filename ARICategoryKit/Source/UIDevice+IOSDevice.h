//
//  UIDevice+IOSDevice.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/26.
//  Copyright © 2019 记忆链网络科技(深圳)有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (IOSDevice)
+ (BOOL)isCurrentiOSVersionEqualToVersion:(NSString *)iOSVersion;
+ (BOOL)isCurrentIOSVersionGreaterThanVersion:(NSString *)iOSVersion;
+ (BOOL)isCurrentIOSVersionGreaterOrEqualToVersion:(NSString *)iOSVersion;
+ (BOOL)isCurrentIOSVersionLessThanVersion:(NSString *)iOSVersion;
+ (BOOL)isCurrentIOSVersionLessThanOrEqualToVersion:(NSString *)iOSVersion;

@end

NS_ASSUME_NONNULL_END
