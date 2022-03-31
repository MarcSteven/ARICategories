//
//  NSString+BoolJudge.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
