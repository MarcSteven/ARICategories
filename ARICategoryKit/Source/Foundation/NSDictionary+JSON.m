//
//  NSDictionary+JSON.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/2.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "NSDictionary+JSON.h"


@implementation NSDictionary (JSON)
- (NSString *)jsonString {
    NSData *infoJsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:infoJsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
+ (NSDictionary *)initWithJsonString:(NSString *)json {
    NSData *infoData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
    return info;
}
@end
