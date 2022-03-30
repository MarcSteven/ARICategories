//
//  NSDictionary+JSON.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/2.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JSON)
- (NSString *)jsonString;
+ (NSDictionary *)initWithJsonString:(NSString *)json;

@end

NS_ASSUME_NONNULL_END
