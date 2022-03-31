//
//  NSData+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Common)

/**
 *  字符串base64转data
 *
 *  @param string 传入字符串
 */
+ (NSData *)po_dataForBase64EncodedString:(NSString *)string;

/**
 *  data转base64 string
 *
 *  @param wrapWidth 换行长度  76  64
 */
- (NSString *)po_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

/**
 *  data转base64 string 换行长度默认64
 */
- (NSString *)po_base64EncodedString;

/**
 *  data转UTF8 string
 */
- (NSString *)po_UTF8String;

/**
 *  data转ASCII string
 */
- (NSString *)po_ASCIIString;

/**
 NSData 转  十六进制string
 
 @return NSString类型的十六进制string
 */
- (NSString *)po_convertDataToHexString;

/**
 NSData 转 NSString
 
 @return NSString类型的字符串
 */
- (NSString *)po_dataToString;

/**
 生成RCR16值
 
 @return NSData类型
 */
- (NSData *)po_crc16;

@end

NS_ASSUME_NONNULL_END
