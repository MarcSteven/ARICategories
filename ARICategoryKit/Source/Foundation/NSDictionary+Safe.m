//
//  NSDictionary+Safe.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/2.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "MSCCommon.h"

#define isValidKey(key) ((key) != nil && ![key isKindOfClass:[NSNull class]])
#define isValidValue(value) ((value) !=nil && ![value isKindOfClass:[NSNull class]])
@implementation NSDictionary (Safe)
- (id)safeObjectForKey:(id)key {
    if (!isValidKey(key)) {
        return nil;
    }
    id objc = [self objectForKey:key];
    if (!isValidValue(objc)) {
        return nil;
    }
    return objc;
    
}
- (int)intValueForKey:(id)key {
    id objc = [self safeObjectForKey:key];
    return [objc intValue];
}
- (double)doubleValueForKey:(id)key {
    id objc = [self safeObjectForKey:key];
    return [objc doubleValue];
}
-(NSString *)stringValueForKey:(id)key {
    id objc = [self safeObjectForKey:key];
    return [objc stringValue];
}


@end

@implementation NSMutableDictionary (Safe)

- (void)safeSetObject:(id)anObject forKey:(id)key {
    if (!isValidKey(key)) {
        return;
    }
    if ([key isKindOfClass:[NSString class]]) {
        [self setValue:anObject forKey:key];
    }
    else {
        if (anObject != nil) {
            [self setObject:anObject forKey:key];
        }
        else {
            [self removeObjectForKey:key];
        }
    }
}
- (void)setIntValue:(int)value forKey:(id)aKey {
    [self safeSetObject:[NSNumber numberWithInt:value] forKey:aKey];
}
- (void)setDoubleValue:(double)value forKey:(id)key {
    [self safeSetObject:[NSNumber numberWithDouble:value] forKey:key];
}
- (void)setStringValueForKey:(NSString *)string forKey:(id)aKey {
    [self safeSetObject:string forKey:aKey];
}
@end

@implementation NSDictionary (DeleteNullObject)

- (NSString *)deleteNullObject:(NSString *)key {
    return checkNull([self objectForKey:key]);
}

@end
