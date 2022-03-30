//
//  NSData+Conversion.h
//  test
//
//  Created by Marc Zhao on 2020/1/17.
//  Copyright © 2020 Marc Zhao. All rights reserved.
//




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Conversion)
#pragma mark - string conversion
- (NSString *)hexadecimalString;

@end

NS_ASSUME_NONNULL_END
