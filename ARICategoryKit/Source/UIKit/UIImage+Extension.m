//
//  UIImage+Extension.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/10.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "UIImage+Extension.h"



@implementation UIImage (Color)

static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}
+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = edgeSizeFromCornerRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath * rounderRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    rounderRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [rounderRect fill];
    [rounderRect stroke];
    [rounderRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}
+ (UIImage *)buttonImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor shadowInsets:(UIEdgeInsets)shadowInset {
    UIImage *topImage = [self imageWithColor:color cornerRadius:cornerRadius];
    UIImage *bottomImage = [self  imageWithColor:shadowColor cornerRadius:cornerRadius];
    CGFloat totalHeight = edgeSizeFromCornerRadius(cornerRadius) + shadowInset.top + shadowInset.bottom;
    CGFloat totalWidth = edgeSizeFromCornerRadius(cornerRadius) + shadowInset.left + shadowInset.right;
    CGFloat topWidth = edgeSizeFromCornerRadius(cornerRadius);
    CGFloat topHeight = edgeSizeFromCornerRadius(cornerRadius);
    CGRect topRect = CGRectMake(shadowInset.left, shadowInset.top, topWidth, topHeight);
    CGRect bottomRect = CGRectMake(0, 0, totalWidth, totalHeight);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(totalWidth, totalHeight), NO, 0.0f);
    if (!CGRectEqualToRect(bottomRect, topRect)) {
        [bottomImage drawInRect:bottomRect];
    }
    [topImage drawInRect:topRect];
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIEdgeInsets resizeableInsets = UIEdgeInsetsMake(cornerRadius + shadowInset.top, cornerRadius + shadowInset.left, cornerRadius + shadowInset.bottom, cornerRadius + shadowInset.right);
    UIGraphicsEndImageContext();
    return [buttonImage resizableImageWithCapInsets:resizeableInsets];
}
- (UIImage *)imageWithMiniumSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width
                                                      , size.height), NO, 0.0f);
    [self drawInRect:rect];
    UIImage * resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [resized resizableImageWithCapInsets:UIEdgeInsetsMake(size.height / 2, size.width /2 , size.height / 2, size.width /2)];
    
}
+ (UIImage *)stepperPlusImageWithColor:(UIColor *)color {
    CGFloat iconEdgeSize = 15;
    CGFloat iconInternalEdgeSize = 3;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(iconEdgeSize, iconEdgeSize), NO, 0.0f);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [color setFill];
    CGFloat padding = (iconEdgeSize - iconInternalEdgeSize ) /2;
    CGContextFillRect(ref, CGRectMake(padding, 0, iconInternalEdgeSize, iconEdgeSize));
    CGContextFillRect(ref, CGRectMake(0, padding, iconEdgeSize, iconInternalEdgeSize));
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)stepperMinusImageWithColor:(UIColor *)color {
    CGFloat iconEdgeSize = 15;
    CGFloat iconInternalEdgeSize = 3;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(iconEdgeSize, iconEdgeSize), NO, 0.0f);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [color setFill];
    CGFloat padding = (iconEdgeSize - iconInternalEdgeSize) / 2;
    CGContextFillRect(ref, CGRectMake(0, padding, iconEdgeSize, iconInternalEdgeSize));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)backgroundButtonImageWithColor:(UIColor *)backgroundColor barMetrics:(UIBarMetrics)metrics cornerRadius:(CGFloat)cornerRadius {
    CGSize size;
    if (metrics == UIBarMetricsDefault) {
        size = CGSizeMake(50, 30);
    }else {
        size = CGSizeMake(60, 23);
    }
    UIBezierPath *path = [self bezierPathForBackButtonInRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [backgroundColor setFill];
    [path addClip];
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if ([image respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
        return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, 15, cornerRadius, cornerRadius) resizingMode:UIImageResizingModeStretch];
        
    }else {
        return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, 15, cornerRadius, cornerRadius)];
    }
    
}
+ (UIBezierPath *) bezierPathForBackButtonInRect:(CGRect)rect cornerRadius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint mPoint = CGPointMake(CGRectGetMaxX(rect) - radius, rect.origin.y);
    CGPoint ctrlPoint = mPoint;
    [path moveToPoint:mPoint];
    
    ctrlPoint.y += radius;
    mPoint.x += radius;
    mPoint.y += radius;
    if (radius > 0) [path addArcWithCenter:ctrlPoint radius:radius startAngle:(float)M_PI + (float)M_PI_2 endAngle:0 clockwise:YES];
    
    mPoint.y = CGRectGetMaxY(rect) - radius;
    [path addLineToPoint:mPoint];
    
    ctrlPoint = mPoint;
    mPoint.y += radius;
    mPoint.x -= radius;
    ctrlPoint.x -= radius;
    if (radius > 0) [path addArcWithCenter:ctrlPoint radius:radius startAngle:0 endAngle:(float)M_PI_2 clockwise:YES];
    
    mPoint.x = rect.origin.x + (10.0f);
    [path addLineToPoint:mPoint];
    
    [path addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMidY(rect))];
    
    mPoint.y = rect.origin.y;
    [path addLineToPoint:mPoint];
    
    [path closePath];
    return path;
}
@end


@implementation UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage];
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

- (UIImage *) resampleWidth:(CGFloat) w {
    CGFloat h = self.size.height * (w / self.size.width);
    return [self scaleToSize:CGSizeMake(w, h)];
}

- (UIImage *) resampleHeight:(CGFloat) h {
    CGFloat w = self.size.width * (h / self.size.height);
    return [self scaleToSize:CGSizeMake(w, h)];
}

- (UIImage *) resampleCropCenter:(CGSize ) size {
    UIImage *img = nil;
    CGFloat fw = self.size.width /size.width;
    CGFloat fh = self.size.height / size.height;
    if (fw > fh) {
        CGFloat w = self.size.width * (size.height / self.size.height);
        img = [self resampleWidth:w];
    } else {
        CGFloat h = self.size.height * (size.width / self.size.width);
        img = [self resampleHeight:h];
    }
    if (img != nil) {
        CGFloat x = (img.size.width - size.width) /2;
        CGFloat y = (img.size.height - size.height) /2;
        return [img cropToRect:CGRectMake(x,y,size.width,size.height)];
    }
    
    return [self scaleToSize:size];
}

- (UIImage*)cropToRect:(CGRect)rect {
    //create a context to do our clipping in
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //create a rect with the size we want to crop the image to
    //the X and Y here are zero so we start at the beginning of our
    //newly created context
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect( currentContext, clippedRect);
    
    //create a rect equivalent to the full size of the image
    //offset the rect by the X and Y we want to start the crop
    //from in order to cut off anything before them
    CGRect drawRect = CGRectMake(rect.origin.x * -1,
                                 rect.origin.y * -1,
                                 self.size.width,
                                 self.size.height);
    [self drawInRect:drawRect];
    
    
    //pull the image from our cropped context
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    //Note: this is autoreleased
    return cropped;
}

@end
