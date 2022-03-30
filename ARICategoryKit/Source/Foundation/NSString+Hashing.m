//
//  NSString+Hashing.m
//  CrossBorderHelp
//
//  Created by Marc Zhao on 2018/1/10.
//  Copyright © 2018 Marc Zhao. All rights reserved.
//

#import "NSString+Hashing.h"



@implementation NSString (Hashing)
- (NSString *)hmacWithKey:(NSString *)key {
    // pointer to UTF8 representation of strings
    
    const char *ptr = [self UTF8String];
    const char *keyPtr = [key UTF8String];
    //implemented with SHA256,create appropriate buffer(32 bytes)
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    
    //create hash value
    CCHmac(kCCHmacAlgSHA256, keyPtr, kCCKeySizeAES256, ptr, strlen(ptr), buffer);
    //convert HMAC Buffer value to pretty printed nsstring
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0 ; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",buffer[i]];
        
    }
    return output;
    
}
- (NSString *)hashWithType:(MSHashType)type {
    
    //create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // create buffer with length of chosen digest
    NSInteger bufferSize;
    switch (type) {
        case MSHashTypeMD5:
            // 16 bytes
            bufferSize = CC_MD5_DIGEST_LENGTH;
            
            break;
        case MSHashTypeSHA1:
            // 20bytes
            bufferSize = CC_SHA1_DIGEST_LENGTH;
            break;
        case MSHashTypeSHA256:
            // 32 bytes
            bufferSize = CC_SHA256_DIGEST_LENGTH;
            break;
            
        default:
            return nil;
            break;
    }
    unsigned char buffer[bufferSize];
    
    //perform hash calculation and store in buffer
    switch (type) {
        case MSHashTypeMD5:
            CC_MD5(ptr, strlen(ptr), buffer);
            
            break;
        case MSHashTypeSHA1:
            CC_SHA1(ptr, strlen(ptr), buffer);
            break;
        case MSHashTypeSHA256:
            CC_SHA256(ptr, strlen(ptr), buffer);
            break;
        default:
            return  nil;
            
            break;
    }
    //Convert buffer value to pretty printed NSString
    NSMutableString *hashString = [NSMutableString stringWithCapacity:bufferSize * 2];
    for (int i = 0 ; i < bufferSize; i++) {
        [hashString appendFormat:@"%02x",buffer[i]];
    }
    return hashString;

}
- (NSString *)md5 {
    return [self hashWithType:MSHashTypeMD5];
    
}
- (NSString *)sha1 {
    return [self hashWithType:MSHashTypeSHA1];
}
- (NSString *)sha256 {
    return [self hashWithType:MSHashTypeSHA256];
}

@end
