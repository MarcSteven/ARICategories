//
//  NSUserDefaults+Timing.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/3.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (Timing)
//swizzle sync
- (BOOL)swizzleSync;
@end

NS_ASSUME_NONNULL_END
