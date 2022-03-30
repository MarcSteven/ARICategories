//
//  NSString+Hashing.h
//  CrossBorderHelp
//
//  Created by Marc Zhao on 2018/1/10.
//  Copyright © 2018 Marc Zhao. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
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

NS_ASSUME_NONNULL_END
