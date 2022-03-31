//
//  NSString+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Common)

/**
 *  在文字上添加删除线
 *
 *  @param range      划线范围
 *  @param lineWidth  线条宽
 */
- (NSAttributedString *)po_addCenterLineOnStringRange:(NSRange)range lineWidth:(NSInteger)lineWidth;

/**
 *  Attributes法获取字符串size
 *
 *  @param attrs Attributes自定义字典
 *  @param size  文本宽高
 *
 *  @return 新文本宽高
 */
- (CGSize)po_sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size;

/**
 *  获取字符串size ps:默认window宽高
 *
 *  @param font 字体
 *
 *  @return 新文本宽高
 */
- (CGSize)po_sizeWithFont:(UIFont *)font;

/**
 *  获取字符串size
 *
 *  @param font 字体
 *  @param size 文本宽高
 *
 *  @return 新文本宽高
 */
- (CGSize)po_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 *  适用于屏蔽手机号中间4位数
 *
 *  @return 屏蔽处理的字符串
 */
- (NSString *)po_shieldPhone;

/**
 *  适用于屏蔽中间一段字符串
 *
 *  @param left   显示左边字符串数
 *  @param right  显示右边字符串数
 *
 *  @return 屏蔽处理的字符串
 */
- (NSString *)po_shieldAndShowLeftCount:(NSInteger)left rightCount:(NSInteger)right;

/**
 *  反转字符串
 */
- (NSString *)po_stringReverse;

/**
 *  HEX转string.
 *    Example: "68 65 6c 6c 6f" -> "hello"
 */
- (NSString *)po_HEXToString;

/**
 *  string转HEX.
 *    Example: "hello" -> "68656c6c6f"
 */
- (NSString *)po_stringToHEX;

/**
 *  格式化string.
 *  Example: "This is a Test" will return "This is a test" and "this is a test" will return "This is a test"
 */
- (NSString *)po_sentenceCapitalizedString;

/**
 *  拼音带音标
 */
- (NSString *)po_pinyinWithPhoneticSymbol;

/**
 *  拼音
 */
- (NSString *)po_pinyin;

/**
 *  拼音数组
 */
- (NSArray *)po_pinyinArray;

/**
 *  拼音去空格的字符串
 */
- (NSString *)po_pinyinWithoutBlank;

/**
 *  拼音首字母的字符串数组
 */
- (NSArray *)po_pinyinInitialsArray;

/**
 *  拼音首字母的拼接字符串
 */
- (NSString *)po_pinyinInitialsString;

/**
 *  字符串第一个字的首字母
 */
- (NSString *)po_initialString;

/**
 *  金钱转千位符
 *
 *  @param money 金钱
 */
+ (NSString *)po_kilobitMoney:(NSNumber *)money;

/**
 *  金钱转K单位
 */
- (NSString *)po_moneyUnitForK;

/**
 *  数字转质量单位
 */
+ (NSString *)po_sizeWithValue:(NSNumber *)number;

/**
 *  遍历及获取get类型url参数
 */
+ (NSDictionary *)po_paramerWithURL:(NSString *)url;

/**
 *  清除html标签
 */
- (NSString *)po_stringByStrippingHTML;

/**
 *  清除js脚本
 */
- (NSString *)po_stringByRemovingScriptsAndStrippingHTML;

/**
 * 得到去除两边空格和便利字符串除空格后的字符长度
 */
- (NSInteger)po_lengthByTrimCenterWhitespace;

/**
 * 去除两边空格和便利字符串除空格
 */
- (NSString *)po_stringByTrimCenterWhitespace;

/**
 *  去除两边空格
 */
- (NSString *)po_stringByTrimWhitespace;

/**
 *  去除字符串与空行
 */
- (NSString *)po_stringByTrimWhitespaceAndNewlines;

/**
 *  删除两倍或者更多重复的空间
 */
- (NSString *)po_stringByRemoveExtraSpaces;

@end

NS_ASSUME_NONNULL_END
