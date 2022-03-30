//
//  UITextField+Extended.m
//  VetNX
//
//  Created by Marc Zhao on 2017/11/13.
//  Copyright © 2017年 VeNX Corporation Ltd. All rights reserved.
//

#import "UITextField+Extended.h"

@implementation UITextField (Extended)

/// 给textField添加下划线
/// @param color  下划线颜色
- (void)addBottomLineWithColor:(UIColor *)color {
    CALayer *borderLayer = [CALayer layer];
    CGFloat borderWidth = 2;
    borderLayer.name = @"bottomLine";
    borderLayer.borderColor = color.CGColor;
    borderLayer.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, 4);
    borderLayer.borderWidth = borderWidth;
    [self.layer addSublayer:borderLayer];
    self.layer.masksToBounds = YES;
    
}

/// 移除底部线
- (void)removeBottomLine {
    [[self.layer.sublayers copy] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer *subLayer = obj;
        if ([[subLayer name] isEqualToString:@"bottomLine"]) {
            [subLayer removeFromSuperlayer];
        }
    }];
}
@end


@implementation UITextField (MSLimits)

/// 限制空格输入
- (void)limitBlankInput {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (int i = 0; i < self.text.length; i++)
    {
        NSString *str = [self.text substringWithRange:NSMakeRange(i, 1)];
        self.text = [regex stringByReplacingMatchesInString:self.text options:0 range:NSMakeRange(0, [self.text length]) withTemplate:@""];
        
        if ([str isEqualToString:@" "]) {
           
            self.text = nil;
            return;
        }
    }

    
}
@end
