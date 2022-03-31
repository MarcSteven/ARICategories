//
//  UILabel+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "UILabel+Common.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

@implementation UILabel (Common)

- (CGFloat)characterSpace {
    return [objc_getAssociatedObject(self,_cmd) floatValue];
}

- (void)setCharacterSpace:(CGFloat)characterSpace {
    objc_setAssociatedObject(self, @selector(characterSpace), @(characterSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self methodLabelAttributed];
}

- (CGFloat)lineSpace {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setLineSpace:(CGFloat)lineSpace {
    objc_setAssociatedObject(self, @selector(lineSpace), @(lineSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self methodLabelAttributed];
}

- (NSArray<NSString *> *)keywordsArr {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywordsArr:(NSArray<NSString *> *)keywordsArr {
    objc_setAssociatedObject(self, @selector(keywordsArr), keywordsArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self methodLabelAttributed];
}

- (NSString *)keywords {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywords:(NSString *)keywords {
    objc_setAssociatedObject(self, @selector(keywords), keywords, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self methodLabelAttributed];
}

- (UIFont *)keywordsFont {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywordsFont:(UIFont *)keywordsFont {
    objc_setAssociatedObject(self, @selector(keywordsFont), keywordsFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self methodLabelAttributed];
}

- (UIColor *)keywordsColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywordsColor:(UIColor *)keywordsColor {
    objc_setAssociatedObject(self, @selector(keywordsColor), keywordsColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self methodLabelAttributed];
}

- (NSString *)underlineStr {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnderlineStr:(NSString *)underlineStr {
    objc_setAssociatedObject(self, @selector(underlineStr), underlineStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self methodLabelAttributed];
}

- (UIColor *)underlineColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    objc_setAssociatedObject(self, @selector(underlineColor), underlineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self methodLabelAttributed];
}

#pragma mark -

- (void)methodLabelAttributed {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName
                             value:self.font
                             range:NSMakeRange(0,self.text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    
    // 字间距
    if (self.characterSpace > 0) {
        long number = self.characterSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        [attributedString addAttribute:(id)kCTKernAttributeName
                                 value:(__bridge id)num
                                 range:NSMakeRange(0,[attributedString length])];
        
        CFRelease(num);
    }
    
    // 行间距
    if (self.lineSpace > 0) {
        [paragraphStyle setLineSpacing:self.lineSpace];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0,self.text.length)];
    }
    
    // 关键字数组
    if (self.keywordsArr.count) {
        for (NSString *string in self.keywordsArr) {
            
            NSRange itemRange = [self.text rangeOfString:string];
            
            if (self.keywordsFont) {
                [attributedString addAttribute:NSFontAttributeName
                                         value:self.keywordsFont
                                         range:itemRange];
            }
            
            if (self.keywordsColor) {
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:self.keywordsColor
                                         range:itemRange];
            }
            
        }
    }
    
    // 关键字
    if (self.keywords) {
        NSRange itemRange = [self.text rangeOfString:self.keywords];
        
        if (self.keywordsFont) {
            [attributedString addAttribute:NSFontAttributeName
                                     value:self.keywordsFont
                                     range:itemRange];
        }
        
        if (self.keywordsColor) {
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:self.keywordsColor
                                     range:itemRange];
        }
    }
    
    //下划线
    if (self.underlineStr) {
        NSRange itemRange = [self.text rangeOfString:self.underlineStr];
        
        [attributedString addAttribute:NSUnderlineStyleAttributeName
                                 value:@(NSUnderlineStyleSingle)
                                 range:itemRange];
        
        if (self.underlineColor) {
            [attributedString addAttribute:NSUnderlineColorAttributeName
                                     value:self.underlineColor
                                     range:itemRange];
        }
    }
    
    self.attributedText = attributedString;
}

#pragma mark -

- (NSInteger)getSeparatedLinesFromLabel {
    
    NSString *text = [self text];
    UIFont *font = [self font];
    CGRect rect = [self frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines) {
        
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    
    return linesArray.count;
}

@end
