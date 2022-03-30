//
//  NSObject+MSCHelper.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/27.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MSCHelper)

- (NSString *)msc_className;

+ (NSMutableData *)msc_toJsonDataWithObject:(id)object;
- (NSMutableData *)msc_toJsonData;
+ (NSString *)msc_toJsonStringWithObject:(id)object;
- (NSString *)msc_toJsonString;
- (id)msc_filterNullNil;
+ (id)msc_filterNullNillFromObject:(id)object;

@end

NS_ASSUME_NONNULL_END
