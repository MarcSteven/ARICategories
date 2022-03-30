//
//  NSString+SubstringSearch.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/26.
//  Copyright © 2019 记忆链网络科技(深圳)有限公司. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SubstringSearch)

/// 判断字符串是否包含子字符串
/// @param substring 子字符串
- (BOOL)containString:(NSString *)substring;
@end

NS_ASSUME_NONNULL_END
