//
//  UITextField+MSLimits.m
//  MSKit
//
//  Created by Marc Zhao on 2019/10/24.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "UITextField+MSLimits.h"
#import <objc/runtime.h>

@implementation UITextField (MSLimits)

/// 限制空格输入
- (void)limitBlankInput {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (int i = 0; i < self.text.length; i++)
    {
        NSString *str = [self.text substringWithRange:NSMakeRange(i, 1)];
        self.text = [regex stringByReplacingMatchesInString:self.text options:0 range:NSMakeRange(0, [self.text length]) withTemplate:@""];
        
        if ([str isEqualToString:@" "]) {
           
            self.text = nil;
            return;
        }
    }

    
}
@end
