//
//  NSString+Emoji.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Emoji)

/**
 输出一个emoji表情的unicode编码
 
 Example:
 "This is a smiley face :smiley:"
 
 Will be replaced with:
 "This is a smiley face \U0001F604"
 */
- (NSString *)po_stringByReplacingEmojiCheatCodesWithUnicode;

/**
 通过unicode编码输出一个emoji表情
 
 Example:
 "This is a smiley face \U0001F604"
 
 Will be replaced with:
 "This is a smiley face :smiley:"
 */
- (NSString *)po_stringByReplacingEmojiUnicodeWithCheatCodes;

/**
 *  是否包含emoji
 */
- (BOOL)po_isIncludingEmoji;

/**
 *  删除掉字符串包含的emoji
 */
- (NSString *)po_removedEmojiString;

@end

NS_ASSUME_NONNULL_END
