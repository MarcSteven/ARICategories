//
//  NSObject+MSCHelper.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/27.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "NSObject+MSCHelper.h"



@implementation NSObject (MSCHelper)
- (NSString *)msc_className {
    return NSStringFromClass([self class]);
}
- (NSMutableData *)msc_toJsonData {
    return [NSObject msc_toJsonDataWithObject:self];
}
- (NSString *)msc_toJsonString {
    return [NSObject msc_toJsonStringWithObject:self];
}

@end
