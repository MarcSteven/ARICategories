//
//  NSString+SubstringSearch.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/26.
//  Copyright © 2019 记忆链网络科技(深圳)有限公司. All rights reserved.
//

#import "NSString+SubstringSearch.h"




@implementation NSString (SubstringSearch)
-(BOOL)containString:(NSString *)substring {
    NSRange range = [self rangeOfString:substring];
    BOOL found = (range.location != NSNotFound);
    return found;
}

@end
