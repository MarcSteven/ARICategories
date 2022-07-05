//
//  NSString+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>


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




@interface NSString (Encrypt)

/**
 *  获取uuid
 */
+ (NSString *)po_getUUID;

/**
 *  AES加密
 */
- (NSString *)po_encryptedWithAESUsingKey:(NSString *)key andData:(NSData *)data;

/**
 *  AES解密
 */
- (NSString *)po_decryptedWithAESUsingKey:(NSString *)key andData:(NSData *)data;

/**
 *  3DES加密
 */
- (NSString *)po_encryptedWith3DESUsingKey:(NSString *)key andData:(NSData *)data;

/**
 *  3DES解密
 */
- (NSString *)po_decryptedWith3DESUsingKey:(NSString *)key andData:(NSData *)data;

/**
 *  md5加密
 */
- (NSString *)po_md5String;

/**
 *  sha1加密
 */
- (NSString *)po_sha1String;

/**
 *  sha256加密
 */
- (NSString *)po_sha256String;

/**
 *  sha512加密
 */
- (NSString *)po_sha512String;

/**
 hmac md5加密
 
 @param key 密匙
 */
- (NSString *)po_hmacMD5StringWithKey:(NSString *)key;

/**
 hmac sha1加密
 
 @param key 密匙
 */
- (NSString *)po_hmacSHA1StringWithKey:(NSString *)key;

/**
 hmac sha256加密
 
 @param key 密匙
 */
- (NSString *)po_hmacSHA256StringWithKey:(NSString *)key;

/**
 hmac sha512加密

 @param key 密匙
 */
- (NSString *)po_hmacSHA512StringWithKey:(NSString *)key;

@end


@interface NSString (BoolJudge)

/**
 *  是否null字符串
 */
+ (BOOL)po_isNULL:(id)string;

/**
 *  是否email
 */
- (BOOL)po_isEmail;

/**
 *  手机号码的有效性:分电信、联通、移动和小灵通
 */
- (BOOL)po_isMobileNumberClassification;

/**
 *  手机号有效性
 */
- (BOOL)po_isMobileNumber;

/**
 *  简单的身份证有效性
 */
- (BOOL)po_simpleVerifyIdentityCardNum;

/**
 *  正则匹配用户姓名,20位的中文或英文
 */
+ (BOOL)po_checkUserName:(NSString *)userName;

/**
 *  正则匹配用户密码6-18位数字和字母组合
 */
+ (BOOL)po_checkPassword:(NSString *)password;

/**
 *  是否以C开头的字符
 */
- (BOOL)po_isCForNSString;

/**
 *  是否数字或字母
 */
- (BOOL)po_isNumberAndLetter;

/**
 *  是否数字
 */
- (BOOL)po_isNumber;

/**
*  是否数字 且最多含有2位小数
*/
- (BOOL)po_isNumberOrDecimal;

/**
 *  是否字母
 */
- (BOOL)po_isLetter;

/**
 *  精确的身份证号码有效性检测
 *
 *  @param value 身份证号
 */
+ (BOOL)po_accurateVerifyIDCardNumber:(NSString *)value;

/**
 *  是否车牌号
 */
- (BOOL)po_isCarNumber;

/**
 *  是否17位车架号
 */
- (BOOL)po_isCheJiaNumber;

/**
 *  Mac地址有效性
 */
- (BOOL)po_isMacAddress;

/**
 *  网址有效性
 */
- (BOOL)po_isValidUrl;

/**
 *  纯汉字
 */
- (BOOL)po_isValidChinese;

/**
 *  是否包含汉字
 */
- (BOOL)po_isIncludeChinese;

/**
 *  邮政编码
 */
- (BOOL)po_isValidPostalcode;

/**
 *  工商税号
 */
- (BOOL)po_isValidTaxNo;

/**
 是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)po_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)po_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                 containLetter:(BOOL)containLetter
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     digtalDigit   必包含数字个数，containDigtal为true时有效
 @param     containLetter   包含字母
 @param     letterDigit   必包含字母个数，containLetter为true时有效
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)po_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                   digtalDigit:(NSInteger)digtalDigit
                 containLetter:(BOOL)containLetter
                   letterDigit:(NSInteger)letterDigit
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 *  判断URL中是否包含中文
 */
- (BOOL)po_isContainChinese;

/**
 *  是否包含中文
 */
- (BOOL)po_isIncludeChineseInString;

/**
 *  是否包含空格
 */
- (BOOL)po_isContainBlank;

/**
 *  是否包含集合里面的字符串
 */
- (BOOL)po_isContainsCharacterSet:(NSCharacterSet *)set;

@end

@interface NSString (QRCode)

/**
 *  根据字符串获取二维码图片
 *
 *  @param size   二维码size
 */
- (UIImage *)po_loadQRCodeImageWithSize:(CGFloat)size;

/**
 *  根据字符串生成二维码 并添加logo
 *
 *  @param size     二维码size
 *  @param image    logo图片
 *  @param logoSize logosize
 */
- (UIImage *)po_loadQRCodeImageWithSize:(CGFloat)size
                                 byLogo:(UIImage *)image
                            andLogoSize:(CGFloat)logoSize;

@end


@interface NSString (BaseEncode)

/**
 *  Base64转image
 */
- (UIImage *)po_imageForBase64EncodedString;

/**
 *  string转base64
 */
- (NSString *)po_stringForEncodeBase64;

/**
 *  base64转string
 */
- (NSString *)po_stringForDecodeBase64;

/**
 *  string转data
 */
- (NSData *)po_dataForConvertString;

/**
 *  Unicode编码的字符串转成NSString
 */
- (NSString *)po_stringForUnicode;

/**
 *  JSON字符串转成NSDictionary
 */
- (NSDictionary *)po_dictionaryForJSONString;

/**
 *  string转成UTF-8
 */
- (NSString *)po_stringForUTF8Encode;

/**
 *  UTF-8字符串转string
 */
- (NSString *)po_stringForUTF8Decode;

/**
 带字节的string转为NSData
 
 @return NSData类型
 */
- (NSData*)po_convertBytesStringToData;

/**
 十进制转十六进制
 
 @return 十六进制字符串
 */
- (NSString *)po_decimalToHex;

/**
 十进制转十六进制
 length   总长度，不足补0
 @return 十六进制字符串
 */
- (NSString *)po_decimalToHexWithLength:(NSUInteger)length;

/**
 十六进制转十进制
 
 @return 十进制字符串
 */
- (NSString *)po_hexToDecimal;

/*
 二进制转十进制
 
 @return 十进制字符串
 */
- (NSString *)po_binaryToDecimal;

/**
 十进制转二进制
 
 @return 二进制字符串
 */
- (NSString *)po_decimalToBinary;

@end


@interface NSString (Additions)
+ (NSString *)documentPath;
+ (NSString *)cachePath;
+ (NSString *)formatCurDate;
+ (NSString *)getAppVersion;
- (NSString *)removeAllSpace;
+ (NSString *)formatCurDayForVersion;
- (NSURL *)toURL;
- (BOOL)isEmpty;
- (NSString *)trim;
- (BOOL) isOlderVersionThan:(NSString *)otherVersion;
- (BOOL)isNewerVersionThan:(NSString *)otherVersion;
@end



@interface NSString (MSSize)
-(CGFloat)ms_widthOfFont:(UIFont *)font;

-(CGFloat)ms_heightOfFont:(UIFont *)font;
@end

@interface NSString (MSEmoji)
-(BOOL)isEmoji;

- (BOOL)containsEmoji:(NSString *)string;


@end


typedef NS_ENUM(NSUInteger, MSHashType) {
    MSHashTypeMD5 = 0,
    MSHashTypeSHA1,
    MSHashTypeSHA256
};

@interface NSString (Hashing)
- (NSString *)hmacWithKey:(NSString *)key;
- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha256;
- (NSString *)hashWithType:(MSHashType)type;


@end


@interface NSString (Extension)

// 注明文件不需要备份
- (BOOL)addSkipBackupAttributeToItem;

// 获取字符串的区域大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

// 字符串是否包含 piece
- (BOOL)contains:(NSString *)piece;


// 删除字符串开头与结尾的空白符与换行
- (NSString *)trim;

// 判断字符串是否为真并且不为@""
- (BOOL)isValid;
- (BOOL)isUserName;
- (BOOL)isPassword;
- (BOOL)isEmail;

/**
 *  方便的存储关系
 *
 *  
 */
- (id)getObjectValue;
- (NSInteger)getIntValue;
- (BOOL)getBOOLValue;
- (void)setObjectValue:(id)value;
- (void)setIntValue:(NSInteger)value;
- (void)setBOOLValue:(BOOL)value;

- (void)removeObjectValue;

- (NSString *)verticalString;//竖向显示


@end

@interface NSString (ConvertStringToHex)
+ (NSString *)ConvertStringToHexString:(NSString *)string;

@end


@interface NSString (ConvertHexToString)
+ (NSString *)ConvertHexStringToString:(NSString *)hexString;

@end

@interface NSString (ConvertIntToData)

+ (NSData *)convertIntoToData:(int)i;
@end


@interface NSString (SubstringSearch)

/// 判断字符串是否包含子字符串
/// @param substring 子字符串
- (BOOL)containString:(NSString *)substring;
@end


NS_ASSUME_NONNULL_END
