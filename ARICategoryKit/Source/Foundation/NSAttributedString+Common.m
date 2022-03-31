//
//  NSAttributedString+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSAttributedString+Common.h"
#import <UIKit/NSAttributedString.h>
#import <CoreText/CoreText.h>

@implementation NSAttributedString (Common)

+ (NSAttributedString *)po_attributeStringWithContent:(NSString *)content
                                            searchKey:(NSString *)searchKey
                                      forKeyWordColor:(UIColor *)keyWordColor {
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content];
    
    if (searchKey.length > 0) {
        
        NSMutableString *tmpString = [NSMutableString stringWithString:content];
        
        NSRange range = [content rangeOfString:searchKey];
        NSInteger location = 0;
        
        while (range.length > 0) {
            
            [attString addAttribute:NSForegroundColorAttributeName
                              value:keyWordColor
                              range:NSMakeRange(location + range.location,
                                                range.length)];
            
            location += (range.location + range.length);
            
            NSString *string = [tmpString substringWithRange:NSMakeRange(range.location + range.length,
                                                                         content.length - location)];
            tmpString = [NSMutableString stringWithString:string];
            
            range = [string rangeOfString:searchKey];
            
        }
    }
    
    return attString;
}

- (float)po_heightWithContainWidth:(float)width {
    
    int total_height = 0;
    CGFloat maxHH = 100000;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    CGRect drawingRect = CGRectMake(0, 0, width, maxHH);
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    if (linesArray.count == 0) {
        return 0;
    }
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = maxHH - line_y + (int) descent +1;
    CFRelease(textFrame);
    
    return total_height;
}

@end
