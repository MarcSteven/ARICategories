//
//  UIView+MSSize.m
//  MSKit
//
//  Created by Marc Zhao on 2019/10/24.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "UIView+MSSize.h"




@implementation UIView (MSSize)
#pragma mark -setter method
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
#pragma mark - getter method
-(CGFloat)x {
    return self.frame.origin.x;
}
-(CGFloat)y {
    return self.frame.origin.y;
}
-(CGFloat)centerX {
    return self.center.x;
}
- (CGFloat)centerY {
    return self.center.y;
}
-(CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (CGPoint)origin {
    return self.frame.origin;
}
@end
