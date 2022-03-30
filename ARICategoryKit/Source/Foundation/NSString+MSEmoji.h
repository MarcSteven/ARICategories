//
//  NSString+MSEmoji.h
//  MSKit
//
//  Created by Marc Zhao on 2019/10/27.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MSEmoji)
- (BOOL)isEmoji;
- (BOOL)containsEmoji:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
