//
//  NSData+Conversion.m
//  test
//
//  Created by Marc Zhao on 2020/1/17.
//  Copyright © 2020 Marc Zhao. All rights reserved.
//

#import "NSData+Conversion.h"



@implementation NSData (Conversion)
#pragma mark - string conversion

- (NSString *)hexadecimalString {
    const unsigned char *dataBuffer  = (const unsigned char *)[self bytes];
    if (!dataBuffer) {
        return [NSString string];
    }
    NSInteger dataLength = [self length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0 ; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx",(unsigned long)dataBuffer[i]]];
        return [NSString stringWithString:hexString];
    
}
@end
