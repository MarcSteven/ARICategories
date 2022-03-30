//
//  NSArray+Exception.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/2.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "NSArray+Exception.h"


@implementation NSArray (Exception)
- (id)objectForKey:(id)key {
#ifdef DEBUG
    NSAssert(NO, @"NSArray should not call objectForKey, you should check your code");
    return nil;
#else
    return nil;
    
    
#endif
}
@end
