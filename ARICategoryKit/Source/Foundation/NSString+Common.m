//
//  NSString+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSString+Common.h"
#import "CoreText/CTFramesetter.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "NSData+Common.h"




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


@implementation NSString (Emoji)

static NSDictionary * po_s_unicodeToCheatCodes = nil;
static NSDictionary * po_s_cheatCodesToUnicode = nil;

+ (void)po_initializeEmojiCheatCodes {
    NSDictionary *forwardMap = @{
                                 @"😄": @":smile:",
                                 @"😆": @[@":laughing:", @":D"],
                                 @"😊": @":blush:",
                                 @"😃": @[@":smiley:", @":)", @":-)"],
                                 @"☺": @":relaxed:",
                                 @"😏": @":smirk:",
                                 @"😞": @[@":disappointed:", @":("],
                                 @"😍": @":heart_eyes:",
                                 @"😘": @":kissing_heart:",
                                 @"😚": @":kissing_closed_eyes:",
                                 @"😳": @":flushed:",
                                 @"😥": @":relieved:",
                                 @"😌": @":satisfied:",
                                 @"😁": @":grin:",
                                 @"😉": @[@":wink:", @";)", @";-)"],
                                 @"😜": @[@":wink2:", @":P"],
                                 @"😝": @":stuck_out_tongue_closed_eyes:",
                                 @"😀": @":grinning:",
                                 @"😗": @":kissing:",
                                 @"😙": @":kissing_smiling_eyes:",
                                 @"😛": @":stuck_out_tongue:",
                                 @"😴": @":sleeping:",
                                 @"😟": @":worried:",
                                 @"😦": @":frowning:",
                                 @"😧": @":anguished:",
                                 @"😮": @[@":open_mouth:", @":o"],
                                 @"😬": @":grimacing:",
                                 @"😕": @":confused:",
                                 @"😯": @":hushed:",
                                 @"😑": @":expressionless:",
                                 @"😒": @":unamused:",
                                 @"😅": @":sweat_smile:",
                                 @"😓": @":sweat:",
                                 @"😩": @":weary:",
                                 @"😔": @":pensive:",
                                 @"😖": @":confounded:",
                                 @"😨": @":fearful:",
                                 @"😰": @":cold_sweat:",
                                 @"😣": @":persevere:",
                                 @"😢": @":cry:",
                                 @"😭": @":sob:",
                                 @"😂": @":joy:",
                                 @"😲": @":astonished:",
                                 @"😱": @":scream:",
                                 @"😫": @":tired_face:",
                                 @"😠": @":angry:",
                                 @"😡": @":rage:",
                                 @"😤": @":triumph:",
                                 @"😪": @":sleepy:",
                                 @"😋": @":yum:",
                                 @"😷": @":mask:",
                                 @"😎": @":sunglasses:",
                                 @"😵": @":dizzy_face:",
                                 @"👿": @":imp:",
                                 @"😈": @":smiling_imp:",
                                 @"😐": @":neutral_face:",
                                 @"😶": @":no_mouth:",
                                 @"😇": @":innocent:",
                                 @"👽": @":alien:",
                                 @"💛": @":yellow_heart:",
                                 @"💙": @":blue_heart:",
                                 @"💜": @":purple_heart:",
                                 @"❤": @":heart:",
                                 @"💚": @":green_heart:",
                                 @"💔": @":broken_heart:",
                                 @"💓": @":heartbeat:",
                                 @"💗": @":heartpulse:",
                                 @"💕": @":two_hearts:",
                                 @"💞": @":revolving_hearts:",
                                 @"💘": @":cupid:",
                                 @"💖": @":sparkling_heart:",
                                 @"✨": @":sparkles:",
                                 @"⭐️": @":star:",
                                 @"🌟": @":star2:",
                                 @"💫": @":dizzy:",
                                 @"💥": @":boom:",
                                 @"💢": @":anger:",
                                 @"❗": @":exclamation:",
                                 @"❓": @":question:",
                                 @"❕": @":grey_exclamation:",
                                 @"❔": @":grey_question:",
                                 @"💤": @":zzz:",
                                 @"💨": @":dash:",
                                 @"💦": @":sweat_drops:",
                                 @"🎶": @":notes:",
                                 @"🎵": @":musical_note:",
                                 @"🔥": @":fire:",
                                 @"💩": @[@":poop:", @":hankey:", @":shit:"],
                                 @"👍": @[@":+1:", @":thumbsup:"],
                                 @"👎": @[@":-1:", @":thumbsdown:"],
                                 @"👌": @":ok_hand:",
                                 @"👊": @":punch:",
                                 @"✊": @":fist:",
                                 @"✌": @":v:",
                                 @"👋": @":wave:",
                                 @"✋": @":hand:",
                                 @"👐": @":open_hands:",
                                 @"☝": @":point_up:",
                                 @"👇": @":point_down:",
                                 @"👈": @":point_left:",
                                 @"👉": @":point_right:",
                                 @"🙌": @":raised_hands:",
                                 @"🙏": @":pray:",
                                 @"👆": @":point_up_2:",
                                 @"👏": @":clap:",
                                 @"💪": @":muscle:",
                                 @"🚶": @":walking:",
                                 @"🏃": @":runner:",
                                 @"👫": @":couple:",
                                 @"👪": @":family:",
                                 @"👬": @":two_men_holding_hands:",
                                 @"👭": @":two_women_holding_hands:",
                                 @"💃": @":dancer:",
                                 @"👯": @":dancers:",
                                 @"🙆": @":ok_woman:",
                                 @"🙅": @":no_good:",
                                 @"💁": @":information_desk_person:",
                                 @"🙋": @":raised_hand:",
                                 @"👰": @":bride_with_veil:",
                                 @"🙎": @":person_with_pouting_face:",
                                 @"🙍": @":person_frowning:",
                                 @"🙇": @":bow:",
                                 @"💏": @":couplekiss:",
                                 @"💑": @":couple_with_heart:",
                                 @"💆": @":massage:",
                                 @"💇": @":haircut:",
                                 @"💅": @":nail_care:",
                                 @"👦": @":boy:",
                                 @"👧": @":girl:",
                                 @"👩": @":woman:",
                                 @"👨": @":man:",
                                 @"👶": @":baby:",
                                 @"👵": @":older_woman:",
                                 @"👴": @":older_man:",
                                 @"👱": @":person_with_blond_hair:",
                                 @"👲": @":man_with_gua_pi_mao:",
                                 @"👳": @":man_with_turban:",
                                 @"👷": @":construction_worker:",
                                 @"👮": @":cop:",
                                 @"👼": @":angel:",
                                 @"👸": @":princess:",
                                 @"😺": @":smiley_cat:",
                                 @"😸": @":smile_cat:",
                                 @"😻": @":heart_eyes_cat:",
                                 @"😽": @":kissing_cat:",
                                 @"😼": @":smirk_cat:",
                                 @"🙀": @":scream_cat:",
                                 @"😿": @":crying_cat_face:",
                                 @"😹": @":joy_cat:",
                                 @"😾": @":pouting_cat:",
                                 @"👹": @":japanese_ogre:",
                                 @"👺": @":japanese_goblin:",
                                 @"🙈": @":see_no_evil:",
                                 @"🙉": @":hear_no_evil:",
                                 @"🙊": @":speak_no_evil:",
                                 @"💂": @":guardsman:",
                                 @"💀": @":skull:",
                                 @"👣": @":feet:",
                                 @"👄": @":lips:",
                                 @"💋": @":kiss:",
                                 @"💧": @":droplet:",
                                 @"👂": @":ear:",
                                 @"👀": @":eyes:",
                                 @"👃": @":nose:",
                                 @"👅": @":tongue:",
                                 @"💌": @":love_letter:",
                                 @"👤": @":bust_in_silhouette:",
                                 @"👥": @":busts_in_silhouette:",
                                 @"💬": @":speech_balloon:",
                                 @"💭": @":thought_balloon:",
                                 @"☀": @":sunny:",
                                 @"☔": @":umbrella:",
                                 @"☁": @":cloud:",
                                 @"❄": @":snowflake:",
                                 @"⛄": @":snowman:",
                                 @"⚡": @":zap:",
                                 @"🌀": @":cyclone:",
                                 @"🌁": @":foggy:",
                                 @"🌊": @":ocean:",
                                 @"🐱": @":cat:",
                                 @"🐶": @":dog:",
                                 @"🐭": @":mouse:",
                                 @"🐹": @":hamster:",
                                 @"🐰": @":rabbit:",
                                 @"🐺": @":wolf:",
                                 @"🐸": @":frog:",
                                 @"🐯": @":tiger:",
                                 @"🐨": @":koala:",
                                 @"🐻": @":bear:",
                                 @"🐷": @":pig:",
                                 @"🐽": @":pig_nose:",
                                 @"🐮": @":cow:",
                                 @"🐗": @":boar:",
                                 @"🐵": @":monkey_face:",
                                 @"🐒": @":monkey:",
                                 @"🐴": @":horse:",
                                 @"🐎": @":racehorse:",
                                 @"🐫": @":camel:",
                                 @"🐑": @":sheep:",
                                 @"🐘": @":elephant:",
                                 @"🐼": @":panda_face:",
                                 @"🐍": @":snake:",
                                 @"🐦": @":bird:",
                                 @"🐤": @":baby_chick:",
                                 @"🐥": @":hatched_chick:",
                                 @"🐣": @":hatching_chick:",
                                 @"🐔": @":chicken:",
                                 @"🐧": @":penguin:",
                                 @"🐢": @":turtle:",
                                 @"🐛": @":bug:",
                                 @"🐝": @":honeybee:",
                                 @"🐜": @":ant:",
                                 @"🐞": @":beetle:",
                                 @"🐌": @":snail:",
                                 @"🐙": @":octopus:",
                                 @"🐠": @":tropical_fish:",
                                 @"🐟": @":fish:",
                                 @"🐳": @":whale:",
                                 @"🐋": @":whale2:",
                                 @"🐬": @":dolphin:",
                                 @"🐄": @":cow2:",
                                 @"🐏": @":ram:",
                                 @"🐀": @":rat:",
                                 @"🐃": @":water_buffalo:",
                                 @"🐅": @":tiger2:",
                                 @"🐇": @":rabbit2:",
                                 @"🐉": @":dragon:",
                                 @"🐐": @":goat:",
                                 @"🐓": @":rooster:",
                                 @"🐕": @":dog2:",
                                 @"🐖": @":pig2:",
                                 @"🐁": @":mouse2:",
                                 @"🐂": @":ox:",
                                 @"🐲": @":dragon_face:",
                                 @"🐡": @":blowfish:",
                                 @"🐊": @":crocodile:",
                                 @"🐪": @":dromedary_camel:",
                                 @"🐆": @":leopard:",
                                 @"🐈": @":cat2:",
                                 @"🐩": @":poodle:",
                                 @"🐾": @":paw_prints:",
                                 @"💐": @":bouquet:",
                                 @"🌸": @":cherry_blossom:",
                                 @"🌷": @":tulip:",
                                 @"🍀": @":four_leaf_clover:",
                                 @"🌹": @":rose:",
                                 @"🌻": @":sunflower:",
                                 @"🌺": @":hibiscus:",
                                 @"🍁": @":maple_leaf:",
                                 @"🍃": @":leaves:",
                                 @"🍂": @":fallen_leaf:",
                                 @"🌿": @":herb:",
                                 @"🍄": @":mushroom:",
                                 @"🌵": @":cactus:",
                                 @"🌴": @":palm_tree:",
                                 @"🌲": @":evergreen_tree:",
                                 @"🌳": @":deciduous_tree:",
                                 @"🌰": @":chestnut:",
                                 @"🌱": @":seedling:",
                                 @"🌼": @":blossum:",
                                 @"🌾": @":ear_of_rice:",
                                 @"🐚": @":shell:",
                                 @"🌐": @":globe_with_meridians:",
                                 @"🌞": @":sun_with_face:",
                                 @"🌝": @":full_moon_with_face:",
                                 @"🌚": @":new_moon_with_face:",
                                 @"🌑": @":new_moon:",
                                 @"🌒": @":waxing_crescent_moon:",
                                 @"🌓": @":first_quarter_moon:",
                                 @"🌔": @":waxing_gibbous_moon:",
                                 @"🌕": @":full_moon:",
                                 @"🌖": @":waning_gibbous_moon:",
                                 @"🌗": @":last_quarter_moon:",
                                 @"🌘": @":waning_crescent_moon:",
                                 @"🌜": @":last_quarter_moon_with_face:",
                                 @"🌛": @":first_quarter_moon_with_face:",
                                 @"🌙": @":moon:",
                                 @"🌍": @":earth_africa:",
                                 @"🌎": @":earth_americas:",
                                 @"🌏": @":earth_asia:",
                                 @"🌋": @":volcano:",
                                 @"🌌": @":milky_way:",
                                 @"⛅": @":partly_sunny:",
                                 @"🎍": @":bamboo:",
                                 @"💝": @":gift_heart:",
                                 @"🎎": @":dolls:",
                                 @"🎒": @":school_satchel:",
                                 @"🎓": @":mortar_board:",
                                 @"🎏": @":flags:",
                                 @"🎆": @":fireworks:",
                                 @"🎇": @":sparkler:",
                                 @"🎐": @":wind_chime:",
                                 @"🎑": @":rice_scene:",
                                 @"🎃": @":jack_o_lantern:",
                                 @"👻": @":ghost:",
                                 @"🎅": @":santa:",
                                 @"🎱": @":8ball:",
                                 @"⏰": @":alarm_clock:",
                                 @"🍎": @":apple:",
                                 @"🎨": @":art:",
                                 @"🍼": @":baby_bottle:",
                                 @"🎈": @":balloon:",
                                 @"🍌": @":banana:",
                                 @"📊": @":bar_chart:",
                                 @"⚾": @":baseball:",
                                 @"🏀": @":basketball:",
                                 @"🛀": @":bath:",
                                 @"🛁": @":bathtub:",
                                 @"🔋": @":battery:",
                                 @"🍺": @":beer:",
                                 @"🍻": @":beers:",
                                 @"🔔": @":bell:",
                                 @"🍱": @":bento:",
                                 @"🚴": @":bicyclist:",
                                 @"👙": @":bikini:",
                                 @"🎂": @":birthday:",
                                 @"🃏": @":black_joker:",
                                 @"✒": @":black_nib:",
                                 @"📘": @":blue_book:",
                                 @"💣": @":bomb:",
                                 @"🔖": @":bookmark:",
                                 @"📑": @":bookmark_tabs:",
                                 @"📚": @":books:",
                                 @"👢": @":boot:",
                                 @"🎳": @":bowling:",
                                 @"🍞": @":bread:",
                                 @"💼": @":briefcase:",
                                 @"💡": @":bulb:",
                                 @"🍰": @":cake:",
                                 @"📆": @":calendar:",
                                 @"📲": @":calling:",
                                 @"📷": @":camera:",
                                 @"🍬": @":candy:",
                                 @"📇": @":card_index:",
                                 @"💿": @":cd:",
                                 @"📉": @":chart_with_downwards_trend:",
                                 @"📈": @":chart_with_upwards_trend:",
                                 @"🍒": @":cherries:",
                                 @"🍫": @":chocolate_bar:",
                                 @"🎄": @":christmas_tree:",
                                 @"🎬": @":clapper:",
                                 @"📋": @":clipboard:",
                                 @"📕": @":closed_book:",
                                 @"🔐": @":closed_lock_with_key:",
                                 @"🌂": @":closed_umbrella:",
                                 @"♣": @":clubs:",
                                 @"🍸": @":cocktail:",
                                 @"☕": @":coffee:",
                                 @"💻": @":computer:",
                                 @"🎊": @":confetti_ball:",
                                 @"🍪": @":cookie:",
                                 @"🌽": @":corn:",
                                 @"💳": @":credit_card:",
                                 @"👑": @":crown:",
                                 @"🔮": @":crystal_ball:",
                                 @"🍛": @":curry:",
                                 @"🍮": @":custard:",
                                 @"🍡": @":dango:",
                                 @"🎯": @":dart:",
                                 @"📅": @":date:",
                                 @"♦": @":diamonds:",
                                 @"💵": @":dollar:",
                                 @"🚪": @":door:",
                                 @"🍩": @":doughnut:",
                                 @"👗": @":dress:",
                                 @"📀": @":dvd:",
                                 @"📧": @":e-mail:",
                                 @"🍳": @":egg:",
                                 @"🍆": @":eggplant:",
                                 @"🔌": @":electric_plug:",
                                 @"✉": @":email:",
                                 @"💶": @":euro:",
                                 @"👓": @":eyeglasses:",
                                 @"📠": @":fax:",
                                 @"📁": @":file_folder:",
                                 @"🍥": @":fish_cake:",
                                 @"🎣": @":fishing_pole_and_fish:",
                                 @"🔦": @":flashlight:",
                                 @"💾": @":floppy_disk:",
                                 @"🎴": @":flower_playing_cards:",
                                 @"🏈": @":football:",
                                 @"🍴": @":fork_and_knife:",
                                 @"🍤": @":fried_shrimp:",
                                 @"🍟": @":fries:",
                                 @"🎲": @":game_die:",
                                 @"💎": @":gem:",
                                 @"🎁": @":gift:",
                                 @"⛳": @":golf:",
                                 @"🍇": @":grapes:",
                                 @"🍏": @":green_apple:",
                                 @"📗": @":green_book:",
                                 @"🎸": @":guitar:",
                                 @"🔫": @":gun:",
                                 @"🍔": @":hamburger:",
                                 @"🔨": @":hammer:",
                                 @"👜": @":handbag:",
                                 @"🎧": @":headphones:",
                                 @"♥": @":hearts:",
                                 @"🔆": @":high_brightness:",
                                 @"👠": @":high_heel:",
                                 @"🔪": @":hocho:",
                                 @"🍯": @":honey_pot:",
                                 @"🏇": @":horse_racing:",
                                 @"⌛": @":hourglass:",
                                 @"⏳": @":hourglass_flowing_sand:",
                                 @"🍨": @":ice_cream:",
                                 @"🍦": @":icecream:",
                                 @"📥": @":inbox_tray:",
                                 @"📨": @":incoming_envelope:",
                                 @"📱": @":iphone:",
                                 @"🏮": @":izakaya_lantern:",
                                 @"👖": @":jeans:",
                                 @"🔑": @":key:",
                                 @"👘": @":kimono:",
                                 @"📒": @":ledger:",
                                 @"🍋": @":lemon:",
                                 @"💄": @":lipstick:",
                                 @"🔒": @":lock:",
                                 @"🔏": @":lock_with_ink_pen:",
                                 @"🍭": @":lollipop:",
                                 @"➿": @":loop:",
                                 @"📢": @":loudspeaker:",
                                 @"🔅": @":low_brightness:",
                                 @"🔍": @":mag:",
                                 @"🔎": @":mag_right:",
                                 @"🀄": @":mahjong:",
                                 @"📫": @":mailbox:",
                                 @"📪": @":mailbox_closed:",
                                 @"📬": @":mailbox_with_mail:",
                                 @"📭": @":mailbox_with_no_mail:",
                                 @"👞": @":mans_shoe:",
                                 @"🍖": @":meat_on_bone:",
                                 @"📣": @":mega:",
                                 @"🍈": @":melon:",
                                 @"📝": @":memo:",
                                 @"🎤": @":microphone:",
                                 @"🔬": @":microscope:",
                                 @"💽": @":minidisc:",
                                 @"💸": @":money_with_wings:",
                                 @"💰": @":moneybag:",
                                 @"🚵": @":mountain_bicyclist:",
                                 @"🎥": @":movie_camera:",
                                 @"🎹": @":musical_keyboard:",
                                 @"🎼": @":musical_score:",
                                 @"🔇": @":mute:",
                                 @"📛": @":name_badge:",
                                 @"👔": @":necktie:",
                                 @"📰": @":newspaper:",
                                 @"🔕": @":no_bell:",
                                 @"📓": @":notebook:",
                                 @"📔": @":notebook_with_decorative_cover:",
                                 @"🔩": @":nut_and_bolt:",
                                 @"🍢": @":oden:",
                                 @"📂": @":open_file_folder:",
                                 @"📙": @":orange_book:",
                                 @"📤": @":outbox_tray:",
                                 @"📄": @":page_facing_up:",
                                 @"📃": @":page_with_curl:",
                                 @"📟": @":pager:",
                                 @"📎": @":paperclip:",
                                 @"🍑": @":peach:",
                                 @"🍐": @":pear:",
                                 @"✏": @":pencil2:",
                                 @"☎": @":phone:",
                                 @"💊": @":pill:",
                                 @"🍍": @":pineapple:",
                                 @"🍕": @":pizza:",
                                 @"📯": @":postal_horn:",
                                 @"📮": @":postbox:",
                                 @"👝": @":pouch:",
                                 @"🍗": @":poultry_leg:",
                                 @"💷": @":pound:",
                                 @"👛": @":purse:",
                                 @"📌": @":pushpin:",
                                 @"📻": @":radio:",
                                 @"🍜": @":ramen:",
                                 @"🎀": @":ribbon:",
                                 @"🍚": @":rice:",
                                 @"🍙": @":rice_ball:",
                                 @"🍘": @":rice_cracker:",
                                 @"💍": @":ring:",
                                 @"🏉": @":rugby_football:",
                                 @"🎽": @":running_shirt_with_sash:",
                                 @"🍶": @":sake:",
                                 @"👡": @":sandal:",
                                 @"📡": @":satellite:",
                                 @"🎷": @":saxophone:",
                                 @"✂": @":scissors:",
                                 @"📜": @":scroll:",
                                 @"💺": @":seat:",
                                 @"🍧": @":shaved_ice:",
                                 @"👕": @":shirt:",
                                 @"🚿": @":shower:",
                                 @"🎿": @":ski:",
                                 @"🚬": @":smoking:",
                                 @"🏂": @":snowboarder:",
                                 @"⚽": @":soccer:",
                                 @"🔉": @":sound:",
                                 @"👾": @":space_invader:",
                                 @"♠": @":spades:",
                                 @"🍝": @":spaghetti:",
                                 @"🔊": @":speaker:",
                                 @"🍲": @":stew:",
                                 @"📏": @":straight_ruler:",
                                 @"🍓": @":strawberry:",
                                 @"🏄": @":surfer:",
                                 @"🍣": @":sushi:",
                                 @"🍠": @":sweet_potato:",
                                 @"🏊": @":swimmer:",
                                 @"💉": @":syringe:",
                                 @"🎉": @":tada:",
                                 @"🎋": @":tanabata_tree:",
                                 @"🍊": @":tangerine:",
                                 @"🍵": @":tea:",
                                 @"📞": @":telephone_receiver:",
                                 @"🔭": @":telescope:",
                                 @"🎾": @":tennis:",
                                 @"🚽": @":toilet:",
                                 @"🍅": @":tomato:",
                                 @"🎩": @":tophat:",
                                 @"📐": @":triangular_ruler:",
                                 @"🏆": @":trophy:",
                                 @"🍹": @":tropical_drink:",
                                 @"🎺": @":trumpet:",
                                 @"📺": @":tv:",
                                 @"🔓": @":unlock:",
                                 @"📼": @":vhs:",
                                 @"📹": @":video_camera:",
                                 @"🎮": @":video_game:",
                                 @"🎻": @":violin:",
                                 @"⌚": @":watch:",
                                 @"🍉": @":watermelon:",
                                 @"🍷": @":wine_glass:",
                                 @"👚": @":womans_clothes:",
                                 @"👒": @":womans_hat:",
                                 @"🔧": @":wrench:",
                                 @"💴": @":yen:",
                                 @"🚡": @":aerial_tramway:",
                                 @"✈": @":airplane:",
                                 @"🚑": @":ambulance:",
                                 @"⚓": @":anchor:",
                                 @"🚛": @":articulated_lorry:",
                                 @"🏧": @":atm:",
                                 @"🏦": @":bank:",
                                 @"💈": @":barber:",
                                 @"🔰": @":beginner:",
                                 @"🚲": @":bike:",
                                 @"🚙": @":blue_car:",
                                 @"⛵": @":boat:",
                                 @"🌉": @":bridge_at_night:",
                                 @"🚅": @":bullettrain_front:",
                                 @"🚄": @":bullettrain_side:",
                                 @"🚌": @":bus:",
                                 @"🚏": @":busstop:",
                                 @"🚗": @":car:",
                                 @"🎠": @":carousel_horse:",
                                 @"🏁": @":checkered_flag:",
                                 @"⛪": @":church:",
                                 @"🎪": @":circus_tent:",
                                 @"🌇": @":city_sunrise:",
                                 @"🌆": @":city_sunset:",
                                 @"🚧": @":construction:",
                                 @"🏪": @":convenience_store:",
                                 @"🎌": @":crossed_flags:",
                                 @"🏬": @":department_store:",
                                 @"🏰": @":european_castle:",
                                 @"🏤": @":european_post_office:",
                                 @"🏭": @":factory:",
                                 @"🎡": @":ferris_wheel:",
                                 @"🚒": @":fire_engine:",
                                 @"⛲": @":fountain:",
                                 @"⛽": @":fuelpump:",
                                 @"🚁": @":helicopter:",
                                 @"🏥": @":hospital:",
                                 @"🏨": @":hotel:",
                                 @"♨": @":hotsprings:",
                                 @"🏠": @":house:",
                                 @"🏡": @":house_with_garden:",
                                 @"🗾": @":japan:",
                                 @"🏯": @":japanese_castle:",
                                 @"🚈": @":light_rail:",
                                 @"🏩": @":love_hotel:",
                                 @"🚐": @":minibus:",
                                 @"🚝": @":monorail:",
                                 @"🗻": @":mount_fuji:",
                                 @"🚠": @":mountain_cableway:",
                                 @"🚞": @":mountain_railway:",
                                 @"🗿": @":moyai:",
                                 @"🏢": @":office:",
                                 @"🚘": @":oncoming_automobile:",
                                 @"🚍": @":oncoming_bus:",
                                 @"🚔": @":oncoming_police_car:",
                                 @"🚖": @":oncoming_taxi:",
                                 @"🎭": @":performing_arts:",
                                 @"🚓": @":police_car:",
                                 @"🏣": @":post_office:",
                                 @"🚃": @":railway_car:",
                                 @"🌈": @":rainbow:",
                                 @"🚀": @":rocket:",
                                 @"🎢": @":roller_coaster:",
                                 @"🚨": @":rotating_light:",
                                 @"📍": @":round_pushpin:",
                                 @"🚣": @":rowboat:",
                                 @"🏫": @":school:",
                                 @"🚢": @":ship:",
                                 @"🎰": @":slot_machine:",
                                 @"🚤": @":speedboat:",
                                 @"🌠": @":stars:",
                                 @"🌃": @":city-night:",
                                 @"🚉": @":station:",
                                 @"🗽": @":statue_of_liberty:",
                                 @"🚂": @":steam_locomotive:",
                                 @"🌅": @":sunrise:",
                                 @"🌄": @":sunrise_over_mountains:",
                                 @"🚟": @":suspension_railway:",
                                 @"🚕": @":taxi:",
                                 @"⛺": @":tent:",
                                 @"🎫": @":ticket:",
                                 @"🗼": @":tokyo_tower:",
                                 @"🚜": @":tractor:",
                                 @"🚥": @":traffic_light:",
                                 @"🚆": @":train2:",
                                 @"🚊": @":tram:",
                                 @"🚩": @":triangular_flag_on_post:",
                                 @"🚎": @":trolleybus:",
                                 @"🚚": @":truck:",
                                 @"🚦": @":vertical_traffic_light:",
                                 @"⚠": @":warning:",
                                 @"💒": @":wedding:",
                                 @"🇯🇵": @":jp:",
                                 @"🇰🇷": @":kr:",
                                 @"🇨🇳": @":cn:",
                                 @"🇺🇸": @":us:",
                                 @"🇫🇷": @":fr:",
                                 @"🇪🇸": @":es:",
                                 @"🇮🇹": @":it:",
                                 @"🇷🇺": @":ru:",
                                 @"🇬🇧": @":gb:",
                                 @"🇩🇪": @":de:",
                                 @"💯": @":100:",
                                 @"🔢": @":1234:",
                                 @"🅰": @":a:",
                                 @"🆎": @":ab:",
                                 @"🔤": @":abc:",
                                 @"🔡": @":abcd:",
                                 @"🉑": @":accept:",
                                 @"♒": @":aquarius:",
                                 @"♈": @":aries:",
                                 @"◀": @":arrow_backward:",
                                 @"⏬": @":arrow_double_down:",
                                 @"⏫": @":arrow_double_up:",
                                 @"⬇": @":arrow_down:",
                                 @"🔽": @":arrow_down_small:",
                                 @"▶": @":arrow_forward:",
                                 @"⤵": @":arrow_heading_down:",
                                 @"⤴": @":arrow_heading_up:",
                                 @"⬅": @":arrow_left:",
                                 @"↙": @":arrow_lower_left:",
                                 @"↘": @":arrow_lower_right:",
                                 @"➡": @":arrow_right:",
                                 @"↪": @":arrow_right_hook:",
                                 @"⬆": @":arrow_up:",
                                 @"↕": @":arrow_up_down:",
                                 @"🔼": @":arrow_up_small:",
                                 @"↖": @":arrow_upper_left:",
                                 @"↗": @":arrow_upper_right:",
                                 @"🔃": @":arrows_clockwise:",
                                 @"🔄": @":arrows_counterclockwise:",
                                 @"🅱": @":b:",
                                 @"🚼": @":baby_symbol:",
                                 @"🛄": @":baggage_claim:",
                                 @"☑": @":ballot_box_with_check:",
                                 @"‼": @":bangbang:",
                                 @"⚫": @":black_circle:",
                                 @"🔲": @":black_square_button:",
                                 @"♋": @":cancer:",
                                 @"🔠": @":capital_abcd:",
                                 @"♑": @":capricorn:",
                                 @"💹": @":chart:",
                                 @"🚸": @":children_crossing:",
                                 @"🎦": @":cinema:",
                                 @"🆑": @":cl:",
                                 @"🕐": @":clock1:",
                                 @"🕙": @":clock10:",
                                 @"🕥": @":clock1030:",
                                 @"🕚": @":clock11:",
                                 @"🕦": @":clock1130:",
                                 @"🕛": @":clock12:",
                                 @"🕧": @":clock1230:",
                                 @"🕜": @":clock130:",
                                 @"🕑": @":clock2:",
                                 @"🕝": @":clock230:",
                                 @"🕒": @":clock3:",
                                 @"🕞": @":clock330:",
                                 @"🕓": @":clock4:",
                                 @"🕟": @":clock430:",
                                 @"🕔": @":clock5:",
                                 @"🕠": @":clock530:",
                                 @"🕕": @":clock6:",
                                 @"🕡": @":clock630:",
                                 @"🕖": @":clock7:",
                                 @"🕢": @":clock730:",
                                 @"🕗": @":clock8:",
                                 @"🕣": @":clock830:",
                                 @"🕘": @":clock9:",
                                 @"🕤": @":clock930:",
                                 @"㊗": @":congratulations:",
                                 @"🆒": @":cool:",
                                 @"©": @":copyright:",
                                 @"➰": @":curly_loop:",
                                 @"💱": @":currency_exchange:",
                                 @"🛃": @":customs:",
                                 @"💠": @":diamond_shape_with_a_dot_inside:",
                                 @"🚯": @":do_not_litter:",
                                 @"8⃣": @":eight:",
                                 @"✴": @":eight_pointed_black_star:",
                                 @"✳": @":eight_spoked_asterisk:",
                                 @"🔚": @":end:",
                                 @"⏩": @":fast_forward:",
                                 @"5⃣": @":five:",
                                 @"4⃣": @":four:",
                                 @"🆓": @":free:",
                                 @"♊": @":gemini:",
                                 @"#⃣": @":hash:",
                                 @"💟": @":heart_decoration:",
                                 @"✔": @":heavy_check_mark:",
                                 @"➗": @":heavy_division_sign:",
                                 @"💲": @":heavy_dollar_sign:",
                                 @"➖": @":heavy_minus_sign:",
                                 @"✖": @":heavy_multiplication_x:",
                                 @"➕": @":heavy_plus_sign:",
                                 @"🆔": @":id:",
                                 @"🉐": @":ideograph_advantage:",
                                 @"ℹ": @":information_source:",
                                 @"⁉": @":interrobang:",
                                 @"🔟": @":keycap_ten:",
                                 @"🈁": @":koko:",
                                 @"🔵": @":large_blue_circle:",
                                 @"🔷": @":large_blue_diamond:",
                                 @"🔶": @":large_orange_diamond:",
                                 @"🛅": @":left_luggage:",
                                 @"↔": @":left_right_arrow:",
                                 @"↩": @":leftwards_arrow_with_hook:",
                                 @"♌": @":leo:",
                                 @"♎": @":libra:",
                                 @"🔗": @":link:",
                                 @"Ⓜ": @":m:",
                                 @"🚹": @":mens:",
                                 @"🚇": @":metro:",
                                 @"📴": @":mobile_phone_off:",
                                 @"❎": @":negative_squared_cross_mark:",
                                 @"🆕": @":new:",
                                 @"🆖": @":ng:",
                                 @"9⃣": @":nine:",
                                 @"🚳": @":no_bicycles:",
                                 @"⛔": @":no_entry:",
                                 @"🚫": @":no_entry_sign:",
                                 @"📵": @":no_mobile_phones:",
                                 @"🚷": @":no_pedestrians:",
                                 @"🚭": @":no_smoking:",
                                 @"🚱": @":non-potable_water:",
                                 @"⭕": @":o:",
                                 @"🅾": @":o2:",
                                 @"🆗": @":ok:",
                                 @"🔛": @":on:",
                                 @"1⃣": @":one:",
                                 @"⛎": @":ophiuchus:",
                                 @"🅿": @":parking:",
                                 @"〽": @":part_alternation_mark:",
                                 @"🛂": @":passport_control:",
                                 @"♓": @":pisces:",
                                 @"🚰": @":potable_water:",
                                 @"🚮": @":put_litter_in_its_place:",
                                 @"🔘": @":radio_button:",
                                 @"♻": @":recycle:",
                                 @"🔴": @":red_circle:",
                                 @"®": @":registered:",
                                 @"🔁": @":repeat:",
                                 @"🔂": @":repeat_one:",
                                 @"🚻": @":restroom:",
                                 @"⏪": @":rewind:",
                                 @"🈂": @":sa:",
                                 @"♐": @":sagittarius:",
                                 @"♏": @":scorpius:",
                                 @"㊙": @":secret:",
                                 @"7⃣": @":seven:",
                                 @"📶": @":signal_strength:",
                                 @"6⃣": @":six:",
                                 @"🔯": @":six_pointed_star:",
                                 @"🔹": @":small_blue_diamond:",
                                 @"🔸": @":small_orange_diamond:",
                                 @"🔺": @":small_red_triangle:",
                                 @"🔻": @":small_red_triangle_down:",
                                 @"🔜": @":soon:",
                                 @"🆘": @":sos:",
                                 @"🔣": @":symbols:",
                                 @"♉": @":taurus:",
                                 @"3⃣": @":three:",
                                 @"™": @":tm:",
                                 @"🔝": @":top:",
                                 @"🔱": @":trident:",
                                 @"🔀": @":twisted_rightwards_arrows:",
                                 @"2⃣": @":two:",
                                 @"🈹": @":u5272:",
                                 @"🈴": @":u5408:",
                                 @"🈺": @":u55b6:",
                                 @"🈯": @":u6307:",
                                 @"🈷": @":u6708:",
                                 @"🈶": @":u6709:",
                                 @"🈵": @":u6e80:",
                                 @"🈚": @":u7121:",
                                 @"🈸": @":u7533:",
                                 @"🈲": @":u7981:",
                                 @"🈳": @":u7a7a:",
                                 @"🔞": @":underage:",
                                 @"🆙": @":up:",
                                 @"📳": @":vibration_mode:",
                                 @"♍": @":virgo:",
                                 @"🆚": @":vs:",
                                 @"〰": @":wavy_dash:",
                                 @"🚾": @":wc:",
                                 @"♿": @":wheelchair:",
                                 @"✅": @":white_check_mark:",
                                 @"⚪": @":white_circle:",
                                 @"💮": @":white_flower:",
                                 @"🔳": @":white_square_button:",
                                 @"🚺": @":womens:",
                                 @"❌": @":x:",
                                 @"0⃣": @":zero:"
                                 };
    
    NSMutableDictionary *reversedMap = [NSMutableDictionary dictionaryWithCapacity:[forwardMap count]];
    [forwardMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString *object in obj) {
                [reversedMap setObject:key forKey:object];
            }
        } else {
            [reversedMap setObject:key forKey:obj];
        }
    }];
    
    @synchronized(self) {
        po_s_unicodeToCheatCodes = forwardMap;
        po_s_cheatCodesToUnicode = [reversedMap copy];
    }
}

- (NSString *)po_stringByReplacingEmojiCheatCodesWithUnicode {
    if (!po_s_cheatCodesToUnicode) {
        [NSString po_initializeEmojiCheatCodes];
    }
    
    if ([self rangeOfString:@":"].location != NSNotFound) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [po_s_cheatCodesToUnicode enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            [newText replaceOccurrencesOfString:key withString:obj options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    
    return self;
}

- (NSString *)po_stringByReplacingEmojiUnicodeWithCheatCodes {
    if (!po_s_cheatCodesToUnicode) {
        [NSString po_initializeEmojiCheatCodes];
    }
    
    if (self.length) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [po_s_unicodeToCheatCodes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *string = ([obj isKindOfClass:[NSArray class]] ? [obj firstObject] : obj);
            [newText replaceOccurrencesOfString:key withString:string options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    return self;
}

- (BOOL)po_isEmoji {
    
    if ([self po_isOtherEmoji]) {
        return YES;
    }
    const unichar high = [self characterAtIndex:0];
    
    
    // Surrogate pair (U+1D000-1F77F)
    if (0xd800 <= high && high <= 0xdbff) {
        const unichar low = [self characterAtIndex: 1];
        const int codepoint = ((high - 0xd800) * 0x400) + (low - 0xdc00) + 0x10000;
        
        return (0x1d000 <= codepoint && codepoint <= 0x1f77f);
    } else {
        // Not surrogate pair (U+2100-27BF)
        return (0x2100 <= high && high <= 0x27bf);
    }
}

- (BOOL)po_isOtherEmoji {
    NSArray *array = @[@"⭐",@"㊙️",@"㊗️",@"⬅️",@"⬆️",@"⬇️",@"⤴️",@"⤵️",@"#️⃣",@"0️⃣",@"1️⃣",@"2️⃣",@"3️⃣",@"4️⃣",@"5️⃣",@"6️⃣",@"7️⃣",@"8️⃣",@"9️⃣",@"〰",@"©®",@"〽️",@"‼️",@"⁉️",@"⭕️",@"⬛️",@"⬜️",@"⭕",@"",@"⬆",@"⬇",@"⬅",@"㊙",@"㊗",@"⭕",@"©®",@"⤴",@"⤵",@"〰",@"†",@"⟹",@"ツ",@"ღ",@"©",@"®"];
    
    BOOL result = NO;
    for(NSString *string in array){
        if ([self isEqualToString:string]) {
            return YES;
        }
    }
    if ([@"\u2b50\ufe0f" isEqualToString:self]) {
        result = YES;
        
    }
    return result;
}

- (BOOL)po_isIncludingEmoji {
    BOOL __block result = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if ([substring po_isEmoji]) {
                                  *stop = YES;
                                  result = YES;
                              }
                          }];
    
    return result;
}

- (NSString *)po_removedEmojiString {
    
    NSMutableString * __block buffer = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring po_isEmoji])? @"": substring];
                          }];
    
    return buffer;
}

@end





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



@implementation NSString (BoolJudge)

+ (BOOL)po_isNULL:(id)string {
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)po_isEmail {
    NSString *emailRegex = @"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
    
    return [self po_isValidateByRegex:emailRegex];
}

- (BOOL)po_isMobileNumberClassification {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([self po_isValidateByRegex:CM])
        || ([self po_isValidateByRegex:CU])
        || ([self po_isValidateByRegex:CT])
        || ([self po_isValidateByRegex:PHS]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)po_isMobileNumber {
    NSString *mobileRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    return [self po_isValidateByRegex:mobileRegex];
}

- (BOOL)po_isEmailAddress {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self po_isValidateByRegex:emailRegex];
}

- (BOOL)po_simpleVerifyIdentityCardNum {
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self po_isValidateByRegex:regex];
}

- (BOOL)po_isCarNumber {
    //车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    NSString *carRegex = @"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$";//其中\u4e00-\u9fa5表示unicode编码中汉字已编码部分，\u9fa5-\u9fff是保留部分，将来可能会添加
    return [self po_isValidateByRegex:carRegex];
}

- (BOOL)po_isCheJiaNumber {
    NSString *bankNum = @"^(\\d{17})$";
    return [self po_isValidateByRegex:bankNum];
}

- (BOOL)po_isMacAddress {
    NSString *macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    return  [self po_isValidateByRegex:macAddRegex];
}

- (BOOL)po_isValidUrl {
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self po_isValidateByRegex:regex];
}

- (BOOL)po_isValidChinese {
    NSString *chineseRegex = @"^[\u4e00-\u9fa5]+$";
    return [self po_isValidateByRegex:chineseRegex];
}

- (BOOL)po_isIncludeChinese {
    
    if (!self.length) {
        return NO;
    }
    
    for (int i = 0; i < self.length; ++i) {
        unichar ch = [self characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)po_isValidPostalcode {
    NSString *postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self po_isValidateByRegex:postalRegex];
}

- (BOOL)po_isValidTaxNo {
    NSString *taxNoRegex = @"[0-9]\\d{13}([0-9]|X)$";
    return [self po_isValidateByRegex:taxNoRegex];
}

- (BOOL)po_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal {
    //  [\u4e00-\u9fa5A-Za-z0-9_]{4,20}
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    
    NSString *regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%@,%@}", first, hanzi, @(minLenth), @(maxLenth)];
    return [self po_isValidateByRegex:regex];
}

- (BOOL)po_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                 containLetter:(BOOL)containLetter
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal {
    
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    return [self po_isValidateByRegex:regex];
}

- (BOOL)po_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                   digtalDigit:(NSInteger)digtalDigit
                 containLetter:(BOOL)containLetter
                   letterDigit:(NSInteger)letterDigit
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal {
    
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? [NSString stringWithFormat:@"(?=(.*\\d.*){%@})", @(digtalDigit)] : @"";
    NSString *letterRegex = containLetter ? [NSString stringWithFormat:@"(?=(.*[a-zA-Z].*){%@})", @(letterDigit)] : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    return [self po_isValidateByRegex:regex];
}

+ (BOOL)po_checkUserName:(NSString *)userName {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}

+ (BOOL)po_checkPassword:(NSString *)password {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

- (BOOL)po_isCForNSString {
    // @"^C{1}[0-9]{18}$" -> 以C开头的18位字符
    NSString *regex = @"^C{1}[0-9]+$";
    return [self po_isValidateByRegex:regex];
}

- (BOOL)po_isNumberAndLetter {
    NSString *regex = @"^[A-Za-z0-9]+$";
    return [self po_isValidateByRegex:regex];
}

- (BOOL)po_isNumber {
    NSString *regex = @"^[0-9]+$";
    return [self po_isValidateByRegex:regex];
}

- (BOOL)po_isNumberOrDecimal {
    // ^[0-9]+(\\.[0-9]{1,2})?$
    // ^(0*[.]((?!0)\\d|(?!00)\\d{2}))|(\\d*[1-9]\\d*([.]\\d{1,4})?)$
    NSString *regex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    return [self po_isValidateByRegex:regex];
}

- (BOOL)po_isLetter {
    NSString *regex = @"^[A-Za-z]+$";
    return [self po_isValidateByRegex:regex];
}

+ (BOOL)po_accurateVerifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                NSString *test = [value substringWithRange:NSMakeRange(17,1)];
                if ([[M lowercaseString] isEqualToString:[test lowercaseString]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
- (BOOL)po_bankCardluhmCheck{
    NSString *lastNum = [[self substringFromIndex:(self.length -1)] copy];//取出最后一位
    NSString *forwardNum = [[self substringToIndex:(self.length -1)] copy];//前15或18位
    
    NSMutableArray *forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < forwardNum.length; i++) {
        NSString *subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray *forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count - 1); i > -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray *arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray *arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray *arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i = 0; i < forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i % 2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }
        else {//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }
            else {
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal % 10 == 0)? YES : NO;
}

- (BOOL)po_isIPAddress {
    
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    BOOL rc = [self po_isValidateByRegex:regex];
    
    if (rc) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        
        return v;
    }
    
    return NO;
}

- (BOOL)po_isContainChinese {
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)po_isIncludeChineseInString {
    
    for (int i = 0; i < self.length; i++) {
        unichar text = [self characterAtIndex:i];
        if (0x4e00 < text  && text < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)po_isContainBlank {
    
    return [self containsString:@" "];
}

- (BOOL)po_isContainsCharacterSet:(NSCharacterSet *)set {
    NSRange rang = [self rangeOfCharacterFromSet:set];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 正则相关

- (BOOL)po_isValidateByRegex:(NSString *)regex {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

@end

@implementation NSString (QRCode)

#pragma mark - 生成二维码

- (UIImage *)po_loadQRCodeImageWithSize:(CGFloat)size {
    
    return [self loadQRCodeImageFormCIImage:[self loadQRForString] withSize:size];
}

- (UIImage *)po_loadQRCodeImageWithSize:(CGFloat)size
                                 byLogo:(UIImage *)image
                            andLogoSize:(CGFloat)logoSize {
    
    return [self loadQRImage:[self loadQRCodeImageFormCIImage:[self loadQRForString] withSize:size]
             centerLogoImage:image
                    logoSize:logoSize];
}

#pragma mark - private

/**
 *  获取二维码图片
 *
 *  @param image 字符串转换的CIImage
 *  @param size  二维码size
 *
 *  @return 二维码图片
 */
- (UIImage *)loadQRCodeImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent),
                        size/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    // --
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil,
                                                   width, height,
                                                   8, 0, cs,
                                                   (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 *  根据字符串创建过滤器返回二维码
 *
 *  @return 图片
 */
- (CIImage *)loadQRForString {
    
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    return qrFilter.outputImage;
}

/**
 *  在图层中心加图层
 *
 *  @param qrImage   底层图片
 *  @param logoImage 中心图片
 *  @param logoSize  中心图片size
 *
 *  @return 图片
 */
- (UIImage *)loadQRImage:(UIImage *)qrImage
         centerLogoImage:(UIImage *)logoImage
                logoSize:(CGFloat)logoSize {
    
    if (logoSize >= qrImage.size.width) {
        return nil;
    }
    
    if (logoSize >= qrImage.size.height) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(qrImage.size, NO, 0.0);
    [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
    
    CGRect rect = CGRectMake(qrImage.size.width / 2 - logoSize / 2,
                             qrImage.size.height / 2 - logoSize / 2,
                             logoSize, logoSize);
    [logoImage drawInRect:rect];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

@end



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

@implementation NSString (Additions)
+ (NSString *)getAppVersion {
    return [[[NSBundle mainBundle]infoDictionary ] objectForKey:@"CFBundleVersion"];
}
+ (NSString *)documentPath {
    static NSString *path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] copy];
        [NSString addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    });
    return path;
}
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
        return YES;
}
+ (NSString *)cachePath {
    static NSString *path = nil;
    if (!path) {
        path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] copy];
        
    }
    return  path;
}
+ (NSString *)formatCurDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSString *result = [dateFormatter stringFromDate:[NSDate date]];
    return  result;
    
}
+ (NSString *)formatCurDayForVersion {
    NSDateFormatter *dateFormatter = [[ NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *result = [dateFormatter stringFromDate:[NSDate date]];
    return result;
}
- (NSURL *)toURL {
   
    return  [NSURL URLWithString:[self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
  
}
- (BOOL)isEmpty {
    return nil == self || 0 == [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length];
}
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (BOOL)isOlderVersionThan:(NSString *)otherVersion {
    return [self compare:otherVersion options:NSNumericSearch] == NSOrderedAscending;
}
- (BOOL)isNewerVersionThan:(NSString *)otherVersion {
    return [self compare:otherVersion options:NSNumericSearch] == NSOrderedDescending;
}
- (NSString *)removeAllSpace {
    NSString *result = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"   " withString:@""];
    return result;
}
@end


@implementation NSString (MSSize)
- (CGFloat)ms_widthOfFont:(UIFont *)font {
    NSDictionary * attributeDic = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attributeDic context:nil];
    return rect.size.width;
}
- (CGFloat)ms_heightOfFont:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    return rect.size.height;
    
}

@end


@implementation NSString (MSEmoji)
-(BOOL)isEmoji {
        const unichar high = [self characterAtIndex:0];
        
        // Surrogate pair (U+1D000-1F77F)
        if (0xd800 <= high && high <= 0xdbff && self.length >= 2) {
            const unichar low = [self characterAtIndex:1];
            const int codepoint = ((high - 0xd800) * 0x400) + (low - 0xdc00) + 0x10000;
            
            return (0x1d000 <= codepoint && codepoint <= 0x1f77f);
            
            // Not surrogate pair (U+2100-27BF)
        } else {
            return (0x2100 <= high && high <= 0x27bf);
        }
    }

- (BOOL)containsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs<= 0xdbff) {
            if (substring.length >1 ) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = (( hs - 0xd800 ) * 0x400) + (ls - 0xdc00) +0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        }else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls ==0x20e3) {
                returnValue = YES;
            }
        }else {
            //No surrogate

            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }        }
    }];
    return returnValue;
}

@end

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


@implementation NSString (Extension)

// 注明文件不需要备份
- (BOOL)addSkipBackupAttributeToItem
{
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:self];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success)
    {
//        NSLogD(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}

// 获取字符串的区域大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - Contains

// 字符串是否包含 piece
- (BOOL)contains:(NSString *)piece
{
    return ([self rangeOfString:piece].location != NSNotFound);
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isValid
{
    if (self && ![self isEqualToString:@""])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isUserName
{
    NSString *regex = @"(^[A-Za-z0-9]{4,18}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNickName
{
    NSString *regex = @"(^[A-Za-z0-9-_]{1,10}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPassword
{
    NSString *        regex = @"(^[A-Za-z0-9]{8,14}$)";
    NSPredicate *    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}+[\\.[A-Za-z]{2,4}]?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}



- (NSString *)verticalString{
    NSMutableString * str = [[NSMutableString alloc] initWithString:self];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2 - 1];
    }
    return str;
}

- (void)removeObjectValue{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:self];
}

- (id)getObjectValue
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:self];
}

- (NSInteger)getIntValue
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults integerForKey:self];
}

- (BOOL)getBOOLValue
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults boolForKey:self];
}

- (void)setObjectValue:(id)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:value forKey:self];
    [userDefaults synchronize];
}

- (void)setIntValue:(NSInteger)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:value forKey:self];
    [userDefaults synchronize];
}

- (void)setBOOLValue:(BOOL)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:value forKey:self];
    [userDefaults synchronize];
}





@end

@implementation NSString (ConvertToHexString)

+ (NSString *)ConvertStringToHexString:(NSString *)string {
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for (int i=0;i<[myD length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if ([newHexStr length]==1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
        
    }
    return hexStr;
}

@end


@implementation NSString (ConvertHexToString)


+ (NSString *)ConvertHexStringToString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];

    
    
    return unicodeString;
}

@end

@implementation NSString (ConvertIntToData)

+ (NSData *)convertIntoToData:(int)i {
    NSData *data = [NSData dataWithBytes:&i length:sizeof(i)];
    return data;
}


@end

@implementation NSString (SubstringSearch)

/// judge the string contains substring
/// @param substring substring
-(BOOL)containString:(NSString *)substring {
    NSRange range = [self rangeOfString:substring];
    BOOL found = (range.location != NSNotFound);
    return found;
}
@end
