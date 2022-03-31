//
//  NSData+Encrypt.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Encrypt)

/**
 *  利用AES加密数据
 */
- (NSData *)po_encryptedWithAESUsingKey:(NSString *)key andData:(NSData *)data;

/**
 *  利用AES解密据
 */
- (NSData *)po_decryptedWithAESUsingKey:(NSString *)key andData:(NSData *)data;

/**
 *  利用3DES加密数据
 */
- (NSData *)po_encryptedWith3DESUsingKey:(NSString *)key andData:(NSData *)data;

/**
 *  利用3DES解密数据
 */
- (NSData *)po_decryptedWith3DESUsingKey:(NSString *)key andData:(NSData *)data;

/**
 *  md5加密
 */
- (NSData *)po_md5Data;

/**
 *  sha1加密
 */
- (NSData *)po_sha1Data;

/**
 *  sha256加密
 */
- (NSData *)po_sha256Data;

/**
 *  sha512加密
 */
- (NSData *)po_sha512Data;

/**
 hmac md5加密
 
 @param key 密匙
 */
- (NSData *)po_hmacMD5DataWithKey:(NSData *)key;

/**
 hmac sha1加密
 
 @param key 密匙
 */
- (NSData *)po_hmacSHA1DataWithKey:(NSData *)key;

/**
 hmac sha256加密
 
 @param key 密匙
 */
- (NSData *)po_hmacSHA256DataWithKey:(NSData *)key;

/**
 hmac sha512加密
 
 @param key 密匙
 */
- (NSData *)po_hmacSHA512DataWithKey:(NSData *)key;

@end

NS_ASSUME_NONNULL_END
