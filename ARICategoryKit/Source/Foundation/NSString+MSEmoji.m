//
//  NSString+MSEmoji.m
//  MSKit
//
//  Created by Marc Zhao on 2019/10/27.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "NSString+MSEmoji.h"




@implementation NSString (MSEmoji)
-(BOOL)isEmoji {
        const unichar high = [self characterAtIndex:0];
        
        // Surrogate pair (U+1D000-1F77F)
        if (0xd800 <= high && high <= 0xdbff && self.length >= 2) {
            const unichar low = [self characterAtIndex:1];
            const int codepoint = ((high - 0xd800) * 0x400) + (low - 0xdc00) + 0x10000;
            
            return (0x1d000 <= codepoint && codepoint <= 0x1f77f);
            
            // Not surrogate pair (U+2100-27BF)
        } else {
            return (0x2100 <= high && high <= 0x27bf);
        }
    }

- (BOOL)containsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs<= 0xdbff) {
            if (substring.length >1 ) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = (( hs - 0xd800 ) * 0x400) + (ls - 0xdc00) +0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        }else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls ==0x20e3) {
                returnValue = YES;
            }
        }else {
            //No surrogate

            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }        }
    }];
    return returnValue;
}

@end
