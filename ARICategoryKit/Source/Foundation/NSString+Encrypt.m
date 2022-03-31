//
//  NSString+Encrypt.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "NSData+Common.h"
#import "NSData+Encrypt.h"
#import "NSString+BoolJudge.h"

@implementation NSString (Encrypt)

+ (NSString *)po_getUUID {
    
    CFUUIDRef uuid_ref = CFUUIDCreate(nil);
    CFStringRef uuid_string_ref = CFUUIDCreateString(nil, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString * _Nonnull)(uuid_string_ref)];
    CFRelease(uuid_string_ref);
    
    return uuid;
}

- (NSString *)po_encryptedWithAESUsingKey:(NSString *)key andData:(NSData *)data {
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] po_encryptedWithAESUsingKey:key andData:data];
    NSString *encryptedString = [encrypted po_base64EncodedString];
    
    return encryptedString;
}

- (NSString *)po_decryptedWithAESUsingKey:(NSString *)key andData:(NSData *)data {
    NSData *decrypted = [[NSData po_dataForBase64EncodedString:self] po_decryptedWithAESUsingKey:key andData:data];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}

- (NSString *)po_encryptedWith3DESUsingKey:(NSString *)key andData:(NSData *)data {
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] po_encryptedWith3DESUsingKey:key andData:data];
    NSString *encryptedString = [encrypted po_base64EncodedString];
    
    return encryptedString;
}

- (NSString *)po_decryptedWith3DESUsingKey:(NSString *)key andData:(NSData *)data {
    NSData *decrypted = [[NSData po_dataForBase64EncodedString:self] po_decryptedWith3DESUsingKey:key andData:data];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}

- (NSString *)po_md5String {
    
    if ([NSString po_isNULL:self]) {
        return @"";
    }
    
    const char *value = [self UTF8String];
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), bytes);
    
    return [self po_stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)po_sha1String {
    
    if ([NSString po_isNULL:self]) {
        return @"";
    }
    
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(string, length, bytes);
    
    return [self po_stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)po_sha256String {
    
    if ([NSString po_isNULL:self]) {
        return @"";
    }
    
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(string, length, bytes);
    
    return [self po_stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)po_sha512String {
    
    if ([NSString po_isNULL:self]) {
        return @"";
    }
    
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(string, length, bytes);
    
    return [self po_stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)po_hmacMD5StringWithKey:(NSString *)key {
    return [self po_hmacStringUsingAlg:kCCHmacAlgMD5 withKey:key];
}

- (NSString *)po_hmacSHA1StringWithKey:(NSString *)key {
    return [self po_hmacStringUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSString *)po_hmacSHA256StringWithKey:(NSString *)key {
    return [self po_hmacStringUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

- (NSString *)po_hmacSHA512StringWithKey:(NSString *)key {
    return [self po_hmacStringUsingAlg:kCCHmacAlgSHA512 withKey:key];
}

- (NSString *)po_hmacStringUsingAlg:(CCHmacAlgorithm)alg
                            withKey:(NSString *)key {
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:size];
    CCHmac(alg, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    
    return [self po_stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}

- (NSString *)po_stringFromBytes:(unsigned char *)bytes length:(int)length {
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

@end
