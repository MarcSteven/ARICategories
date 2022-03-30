//
//  NSDictionary+Safe.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/2.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Safe)
- (id)safeObjectForKey:(id)key;
- (int)intValueForKey:(id)key;
- (double)doubleValueForKey:(id)key;
-(NSString *)stringValueForKey:(id)key;

@end

@interface NSMutableDictionary (Safe)
- (void)safeSetObject:(id)anObject forKey:(id)key;
- (void)setIntValue:(int)value forKey:(id)aKey;
- (void)setDoubleValue:(double)value forKey:(id)key;
- (void)setStringValueForKey:(NSString *)string forKey:(id)aKey;


@end

@interface NSDictionary (DeleteNullObject)
- (NSString *)deleteNullObject:(NSString *)key;

@end
NS_ASSUME_NONNULL_END
