//
//  NSString+Encrypt.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
