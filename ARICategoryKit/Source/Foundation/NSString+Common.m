//
//  NSString+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSString+Common.h"
#import "CoreText/CTFramesetter.h"
#import "NSString+BoolJudge.h"

@implementation NSString (Common)

- (NSAttributedString *)po_addCenterLineOnStringRange:(NSRange)range lineWidth:(NSInteger)lineWidth {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    [attributedStr addAttribute:NSStrikethroughStyleAttributeName value:[NSString stringWithFormat:@"%ld", (long)lineWidth] range:range];
    return attributedStr;
}

- (CGSize)po_sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self
                                                                           attributes:attrs];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attributedString);
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, size, NULL);
    CFRelease(framesetter);
    return fitSize;
}

- (CGSize)po_sizeWithFont:(UIFont *)font {
    return [self po_sizeWithFont:font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
}

- (CGSize)po_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    
    resultSize = [self boundingRectWithSize:size
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font}
                                    context:nil].size;
    
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)),
                            MIN(size.height, ceilf(resultSize.height)));
    
    return resultSize;
}

- (NSString *)po_shieldPhone {
    return [self po_shieldAndShowLeftCount:3 rightCount:4];
}

- (NSString *)po_shieldAndShowLeftCount:(NSInteger)left rightCount:(NSInteger)right {
    
    NSInteger total = left + right;
    if (self.length <= total) {
        return self;
    }
    
    NSInteger shieldCount = self.length - total;
    NSString *leftStr = [self substringToIndex:left];
    NSString *rightStr = [self substringFromIndex:self.length - right];
    
    NSString *shieldStr = @"";
    for (NSInteger i = 0; i < shieldCount; ++i) {
        shieldStr = [shieldStr stringByAppendingString:@"*"];
    }
    
    return [NSString stringWithFormat:@"%@%@%@",leftStr,shieldStr,rightStr];
}

- (NSString *)po_stringReverse {
    
    NSMutableString *reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [self length];
    
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[self substringWithRange:subStrRange]];
    }
    return reverseString;
}

- (NSString *)po_HEXToString {
    NSMutableString *newString = [NSMutableString string];
    NSArray *components = [self componentsSeparatedByString:@" "];
    for (NSString * component in components) {
        int value = 0;
        sscanf([component cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [newString appendFormat:@"%c", (char)value];
    }
    return newString;
}

- (NSString *)po_stringToHEX {
    NSUInteger len = [self length];
    unichar *chars = malloc(len * sizeof(unichar));
    [self getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0; i < len; i++ ) {
        [hexString appendFormat:@"%02x", chars[i]];
    }
    free(chars);
    
    return hexString;
}

- (NSString *)po_sentenceCapitalizedString {
    if (![self length]) {
        return @"";
    }
    NSString *uppercase = [[self substringToIndex:1] uppercaseString];
    NSString *lowercase = [[self substringFromIndex:1] lowercaseString];
    
    return [uppercase stringByAppendingString:lowercase];
}

- (NSString *)po_pinyinWithPhoneticSymbol {
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformMandarinLatin, NO);
    return [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)po_pinyin {
    NSMutableString *pinyin = [NSMutableString stringWithString:[self po_pinyinWithPhoneticSymbol]];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSArray *)po_pinyinArray {
    NSArray *array = [[self po_pinyin] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return array;
}

- (NSString *)po_pinyinWithoutBlank {
    NSMutableString *string = [NSMutableString stringWithString:@""];
    for (NSString *str in [self po_pinyinArray]) {
        [string appendString:str];
    }
    return string;
}

- (NSArray *)po_pinyinInitialsArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in [self po_pinyinArray]) {
        if ([str length] > 0) {
            [array addObject:[str substringToIndex:1]];
        }
    }
    return array;
}

- (NSString *)po_pinyinInitialsString {
    NSMutableString *pinyin = [NSMutableString stringWithString:@""];
    for (NSString *str in [self po_pinyinArray]) {
        if ([str length] > 0) {
            [pinyin appendString:[str substringToIndex:1]];
        }
    }
    return pinyin;
}

- (NSString *)po_initialString {
    
    NSArray *array = [self po_pinyinArray];
    if (array.count > 0) {
        return array[0];
    }
    
    return nil;
}

+ (NSString *)po_kilobitMoney:(NSNumber *)money {
    NSNumberFormatter *moneyFormatter = [[NSNumberFormatter alloc] init];
    moneyFormatter.positiveFormat = @"###,##0.00";
    
    return [moneyFormatter stringFromNumber:money];
}

- (NSString *)po_moneyUnitForK {
    
    if (!self.length) {
        return @"";
    }
    
    if (![self po_isNumber]) {
        return self;
    }
    
    if ([self integerValue] < 1000) {
        return self;
    }
    
    NSString *string = [NSString stringWithFormat:@"%.3f", [self integerValue] / 1000.0];
    NSNumber *number = @(string.floatValue);
    
    return [NSString stringWithFormat:@"%@K", number];
}

+ (NSString *)po_sizeWithValue:(NSNumber *)number {
    CGFloat totalSize = number.longValue;
    CGFloat methodSize = 0.0f;
    NSString *sizeString = nil;
    
    if (totalSize > 1000) {
        methodSize = totalSize /1000.0;
        sizeString = [NSString stringWithFormat:@"%.2fKb", methodSize];
        
        if (methodSize > 1000) {
            methodSize = methodSize /1000.0;
            sizeString = [NSString stringWithFormat:@"%.2fMb", methodSize];
            
            if (methodSize > 1000) {
                methodSize = methodSize /1000.0;
                sizeString = [NSString stringWithFormat:@"%.2fGb", methodSize];
            }
        }
    }
    else {
        sizeString = [NSString stringWithFormat:@"%@b", @(totalSize)];
    }
    
    return sizeString;
}

+ (NSDictionary *)po_paramerWithURL:(NSString *)url {
    
    NSRange range = [url rangeOfString:@"?"];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *parametersString = [url substringFromIndex:range.location + 1];
    
    if ([parametersString containsString:@"&"]) {
        
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [parameters valueForKey:key];
            
            if (existValue != nil) {
                
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [parameters setValue:items forKey:key];
                }
                else {
                    [parameters setValue:@[existValue, value] forKey:key];
                }
            }
            else {
                [parameters setValue:value forKey:key];
            }
        }
    }
    else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        if (pairComponents.count == 1) {
            return nil;
        }
        
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        if (key == nil || value == nil) {
            return nil;
        }
        [parameters setValue:value forKey:key];
    }
    
    return parameters;
}

- (NSString *)po_stringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)po_stringByRemovingScriptsAndStrippingHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString po_stringByStrippingHTML];
}

- (NSInteger)po_lengthByTrimCenterWhitespace {
    NSString *string = [self po_stringByTrimCenterWhitespace];
    return string.length;
}

- (NSString *)po_stringByTrimCenterWhitespace {
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)po_stringByTrimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)po_stringByTrimWhitespaceAndNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)po_stringByRemoveExtraSpaces {
    NSString *squashed = [self stringByReplacingOccurrencesOfString:@"[ ]+" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    return [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
