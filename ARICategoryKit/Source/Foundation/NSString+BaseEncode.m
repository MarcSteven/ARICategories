//
//  NSString+BaseEncode.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSString+BaseEncode.h"
#import "NSData+Common.h"

@implementation NSString (BaseEncode)

- (UIImage *)po_imageForBase64EncodedString {
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:imageData scale:2];
}

- (NSString *)po_stringForEncodeBase64 {
    NSData *data = [self po_dataForConvertString];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)po_stringForDecodeBase64 {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [data po_UTF8String];
}

- (NSData *)po_dataForConvertString {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)po_stringForUnicode {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (NSDictionary *)po_dictionaryForJSONString {
    NSError *errorJson;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorJson);
#endif
    }
    return jsonDict;
}

- (NSString *)po_stringForUTF8Encode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)po_stringForUTF8Decode {
    return [self stringByRemovingPercentEncoding];
}

- (NSData*)po_convertBytesStringToData {
    NSMutableData *data = [NSMutableData data];
    for (int idx = 0; idx +2 <= self.length; idx += 2) {
        
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [self substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr];
        
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (NSString *)po_decimalToHex {
    
    long long int intValue = [self intValue];
    NSString *letterValue;
    NSString *string = @"";
    long long int hexValue;
    
    for (int i = 0; i < 9; ++i) {
        hexValue = intValue % 16;
        intValue = intValue / 16;
        switch (hexValue) {
            case 10:
                letterValue = @"A";
                break;
            case 11:
                letterValue = @"B";
                break;
            case 12:
                letterValue = @"C";
                break;
            case 13:
                letterValue = @"D";
                break;
            case 14:
                letterValue = @"E";
                break;
            case 15:
                letterValue = @"F";
                break;
            default:
                letterValue = [[NSString alloc]initWithFormat:@"%lli", hexValue];
        }
        string = [letterValue stringByAppendingString:string];
        if (intValue == 0) {
            break;
        }
    }
    
    return string;
}

- (NSString *)po_decimalToHexWithLength:(NSUInteger)length {
    
    NSString *subString = [self po_decimalToHex];
    NSUInteger moreLength = length - subString.length;
    
    if (moreLength > 0) {
        for (int i = 0; i < moreLength; ++i) {
            subString = [NSString stringWithFormat:@"0%@",subString];
        }
    }
    return subString;
}

- (NSString *)po_hexToDecimal {
    return [NSString stringWithFormat:@"%lu",strtoul([self UTF8String], 0, 16)];
}

- (NSString *)po_binaryToDecimal {
    int value = 0 ;
    int temp = 0 ;
    
    for (int i = 0; i < self.length; ++i) {
        temp = [[self substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, self.length - i - 1);
        value += temp;
    }
    
    NSString *result = [NSString stringWithFormat:@"%d", value];
    return result;
}

- (NSString *)po_decimalToBinary {
    NSInteger num = [self integerValue];
    NSInteger remainder = 0; // 余数
    NSInteger divisor = 0; // 除数
    NSString *prepare = @"";
    
    while (true) {
        remainder = num %2;
        divisor = num /2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d", (int)remainder];
        
        if (divisor == 0) {
            break;
        }
    }
    
    NSString *result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i--) {
        result = [result stringByAppendingFormat:@"%@", [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return [NSString stringWithFormat:@"%08d",[result intValue]];
}

@end
