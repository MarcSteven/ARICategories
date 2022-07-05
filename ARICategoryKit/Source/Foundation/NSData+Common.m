//
//  NSData+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSData+Common.h"

#import <CommonCrypto/CommonCryptor.h>
#include <CommonCrypto/CommonCrypto.h>


@implementation NSData (Common)

+ (NSData *)po_dataForBase64EncodedString:(NSString *)string {
    if (![string length]) return nil;
    NSData *decoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        decoded = [[self alloc] initWithBase64Encoding:[string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])]];
#pragma clang diagnostic pop
    }
    else
#endif
    {
        decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    return [decoded length]? decoded: nil;
}

- (NSString *)po_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth {
    if (![self length]) return nil;
    NSString *encoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        encoded = [self base64Encoding];
#pragma clang diagnostic pop
        
    }
    else
#endif
    {
        switch (wrapWidth)
        {
            case 64:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            case 76:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            }
            default:
            {
                encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
            }
        }
    }
    if (!wrapWidth || wrapWidth >= [encoded length])
    {
        return encoded;
    }
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth)
    {
        if (i + wrapWidth >= [encoded length])
        {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    return result;
}

- (NSString *)po_base64EncodedString {
    return [self po_base64EncodedStringWithWrapWidth:0];
}

- (NSString *)po_UTF8String {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)po_ASCIIString {
    return [[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding];
}

- (NSString *)po_convertDataToHexString {
    
    if (!self || [self length] == 0) {
        return @"";
    }
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[self length]];
    
    [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        
        for (NSInteger i = 0; i < byteRange.length; i++) {
            
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            }
            else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

- (NSString *)po_dataToString {
    
    Byte *bytes = (Byte *)[self bytes];
    NSMutableString *string = [[NSMutableString alloc] init];
    
    for(int i = 0; i < [self length]; ++i) {
        if (i == 0) {
            [string appendString:[NSString stringWithFormat:@"%hhu",bytes[i]]];
        }
        else {
            [string appendString:[NSString stringWithFormat:@",%hhu",bytes[i]]];
        }
    }
    
    return string;
}

- (NSData *)po_crc16 {
    
    const uint8_t *byte = (const uint8_t *)self.bytes;
    uint16_t length = (uint16_t)self.length;
    uint16_t result = generateCRC_16(byte, length);

    NSData *value = [NSData dataWithBytes:&result length:sizeof(result)];

    return value;
}

uint16_t generateCRC_16(const uint8_t *btData, int nLength) {

    if ((btData == NULL) || (nLength <= 0)) {
        NSLog(@"无效数组！");
        return -1;
    }

    uint16_t CRC = 0xFFFF;
    Byte j,Tmp = 0;
    int i;

    for (i = 0; i < nLength; ++i) {
        CRC ^= btData[i];

        for (j = 0; j < 8; ++j) {
            Tmp = CRC & 0x0001;
            CRC = CRC >> 1;
            if (Tmp) CRC = (CRC ^ 0xA001);
        }
    }
    
    return ((CRC >> 8) + (CRC << 8));
}

@end



@implementation NSData (UTF8)
- (NSString *)asUTF8String {
    return [[NSString alloc]initWithData:self encoding:NSUTF8StringEncoding];
    
}

@end

@implementation NSData (Encrypt)

- (NSData *)po_encryptedWithAESUsingKey:(NSString *)key andData:(NSData *)data {
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t dataMoved;
    NSMutableData *encryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];
    
    CCCryptorStatus status = CCCrypt(kCCEncrypt,                    // kCCEncrypt or kCCDecrypt
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,         // Padding option for CBC Mode
                                     keyData.bytes,
                                     keyData.length,
                                     data.bytes,
                                     self.bytes,
                                     self.length,
                                     encryptedData.mutableBytes,    // encrypted data out
                                     encryptedData.length,
                                     &dataMoved);                   // total data moved
    
    if (status == kCCSuccess) {
        encryptedData.length = dataMoved;
        return encryptedData;
    }
    
    return nil;
}

- (NSData *)po_decryptedWithAESUsingKey:(NSString *)key andData:(NSData *)data {
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t dataMoved;
    NSMutableData *decryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt,                    // kCCEncrypt or kCCDecrypt
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,         // Padding option for CBC Mode
                                     keyData.bytes,
                                     keyData.length,
                                     data.bytes,
                                     self.bytes,
                                     self.length,
                                     decryptedData.mutableBytes,    // encrypted data out
                                     decryptedData.length,
                                     &dataMoved);                   // total data moved
    
    if (result == kCCSuccess) {
        decryptedData.length = dataMoved;
        return decryptedData;
    }
    
    return nil;
}

- (NSData *)po_encryptedWith3DESUsingKey:(NSString *)key andData:(NSData *)data {
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t dataMoved;
    NSMutableData *encryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSize3DES];
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt,                    // kCCEncrypt or kCCDecrypt
                                     kCCAlgorithm3DES,
                                     kCCOptionPKCS7Padding,         // Padding option for CBC Mode
                                     keyData.bytes,
                                     keyData.length,
                                     data.bytes,
                                     self.bytes,
                                     self.length,
                                     encryptedData.mutableBytes,    // encrypted data out
                                     encryptedData.length,
                                     &dataMoved);                   // total data moved
    
    if (result == kCCSuccess) {
        encryptedData.length = dataMoved;
        return encryptedData;
    }
    
    return nil;
}

- (NSData *)po_decryptedWith3DESUsingKey:(NSString *)key andData:(NSData *)data {
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t dataMoved;
    NSMutableData *decryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSize3DES];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt,                    // kCCEncrypt or kCCDecrypt
                                     kCCAlgorithm3DES,
                                     kCCOptionPKCS7Padding,         // Padding option for CBC Mode
                                     keyData.bytes,
                                     keyData.length,
                                     data.bytes,
                                     self.bytes,
                                     self.length,
                                     decryptedData.mutableBytes,    // encrypted data out
                                     decryptedData.length,
                                     &dataMoved);                   // total data moved
    
    if (result == kCCSuccess) {
        decryptedData.length = dataMoved;
        return decryptedData;
    }
    
    return nil;
}

- (NSData *)po_md5Data {
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, bytes);
    return [NSData dataWithBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)po_sha1Data {
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, bytes);
    return [NSData dataWithBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *)po_sha256Data {
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, bytes);
    return [NSData dataWithBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSData *)po_sha512Data {
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, bytes);
    return [NSData dataWithBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

- (NSData *)po_hmacMD5DataWithKey:(NSData *)key {
    return [self po_hmacDataUsingAlg:kCCHmacAlgMD5 withKey:key];
}

- (NSData *)po_hmacSHA1DataWithKey:(NSData *)key {
    return [self po_hmacDataUsingAlg:kCCHmacAlgSHA1 withKey:key];
}

- (NSData *)po_hmacSHA256DataWithKey:(NSData *)key {
    return [self po_hmacDataUsingAlg:kCCHmacAlgSHA256 withKey:key];
}

- (NSData *)po_hmacSHA512DataWithKey:(NSData *)key {
    return [self po_hmacDataUsingAlg:kCCHmacAlgSHA512 withKey:key];
}


- (NSData *)po_hmacDataUsingAlg:(CCHmacAlgorithm)alg withKey:(NSData *)key {
    
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
    unsigned char result[size];
    CCHmac(alg, [key bytes], key.length, self.bytes, self.length, result);
    return [NSData dataWithBytes:result length:size];
}

@end

