//
//  UIDevice+IOSDevice.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/26.
//  Copyright © 2019 记忆链网络科技(深圳)有限公司. All rights reserved.
//

#import "UIDevice+IOSDevice.h"



@implementation UIDevice (IOSDevice)
+ (BOOL)isCurrentiOSVersionEqualToVersion:(NSString *)iOSVersion {
    return [[[UIDevice currentDevice]systemVersion] compare:iOSVersion options:NSNumericSearch] == NSOrderedSame;
    
}
+ (BOOL)isCurrentIOSVersionGreaterThanVersion:(NSString *)iOSVersion {
    return [[[UIDevice currentDevice]systemVersion] compare:iOSVersion options:NSNumericSearch] == NSOrderedDescending;
}
+(BOOL)isCurrentIOSVersionGreaterOrEqualToVersion:(NSString *)iOSVersion {
    return [[[UIDevice currentDevice]systemVersion] compare:iOSVersion options:NSNumericSearch] != NSOrderedDescending;
}
+ (BOOL)isCurrentIOSVersionLessThanVersion:(NSString *)iOSVersion {
    return [[[UIDevice currentDevice]systemVersion]compare:iOSVersion options:NSNumericSearch] == NSOrderedAscending;
}
+ (BOOL)isCurrentIOSVersionLessThanOrEqualToVersion:(NSString *)iOSVersion {
    return [[[UIDevice currentDevice]systemVersion]compare:iOSVersion options:NSNumericSearch] != NSOrderedAscending;
}
@end
