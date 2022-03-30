//
//  NSString+MSSize.m
//  MSKit
//
//  Created by Marc Zhao on 2019/10/24.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "NSString+MSSize.h"

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
