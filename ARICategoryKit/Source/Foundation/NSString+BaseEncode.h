//
//  NSString+BaseEncode.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
