//
//  UIImage+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "UIImage+Common.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Common)

- (NSString *)po_base64EncodedStringForPNG {
    
    NSData *imageData = UIImagePNGRepresentation(self);
    NSString *base64EncodedString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64EncodedString;
}

- (NSString *)po_base64EncodedStringForJPEG {
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1.0f);
    NSString *base64EncodedString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64EncodedString;
}

+ (UIImage *)po_getLaunchImage {
    CGSize viewSize = [UIApplication sharedApplication].delegate.window.bounds.size;
    NSString *viewOrientation = @"Portrait";//横屏 @"Landscape"
    __block NSString *launchImage = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    [imagesDict enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary* dict = (NSDictionary *)obj;
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
        
    }];
    
    return [UIImage imageNamed:launchImage];
}

+ (UIImage *)po_getAppIcon {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *path = @"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles";
    NSString *iconName = [[infoDict valueForKeyPath:path] lastObject];
    
    return  [UIImage imageNamed:iconName];
}

+ (UIImage *)po_imageAlwaysOriginalWithNamed:(NSString *)imageName {
    return [[UIImage imageNamed:imageName] po_imageWithRenderingModeAlwaysOriginal];
}

- (UIImage *)po_imageWithRenderingModeAlwaysOriginal {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)po_imageReduceToSize:(CGRect)aRect {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(aRect.size.width, aRect.size.height), NO, 0.0);
    [self drawInRect:aRect];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)po_imageCircleForBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    
    CGFloat imageWH = self.size.width;
    CGFloat ovalWH = imageWH + 2 * borderWidth;
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    [borderColor set];
    [path fill];
    
    // 设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderWidth, borderWidth, imageWH, imageWH)];
    [clipPath addClip];
    
    [self drawAtPoint:CGPointMake(borderWidth, borderWidth)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage *)po_grayImage {
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil, width, height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}

- (UIColor *)po_colorWithPoint:(CGPoint)point {
    if (point.x < 0 || point.y < 0) return nil;
    
    CGImageRef imageRef = self.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    if (point.x >= width || point.y >= height) return nil;
    
    unsigned char *rawData = malloc(height * width * 4);
    if (!rawData) return nil;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast
                                                 | kCGBitmapByteOrder32Big);
    if (!context) {
        free(rawData);
        return nil;
    }
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
    UIColor *result = nil;
    result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return result;
}

+ (UIImage *)po_imageWithColor:(UIColor *)aColor {
    return [UIImage po_imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+ (UIImage *)po_imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame {
    UIGraphicsBeginImageContextWithOptions(aFrame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)po_compressImageToMaxFileSize:(NSInteger)maxFileSize {
    
    CGFloat compression = 0.8f;
    CGFloat minCompression = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    while ([imageData length] > maxFileSize && compression > minCompression) {
        compression -= 0.01;
        imageData = UIImageJPEGRepresentation(self, compression);
#ifdef DEBUG
        NSLog(@"imageData %lu",(unsigned long)[imageData length]);
#endif
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

- (UIImage *)po_scaledToSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat scaleFactor = 0.0;
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
    }
    scaleFactor = MIN(scaleFactor, 1.0);
    CGFloat targetWidth = imageSize.width* scaleFactor;
    CGFloat targetHeight = imageSize.height* scaleFactor;
    
    targetSize = CGSizeMake(floorf(targetWidth), floorf(targetHeight));
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    [sourceImage drawInRect:CGRectMake(0, 0, ceilf(targetWidth), ceilf(targetHeight))];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        newImage = sourceImage;
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)po_scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality{
    if (highQuality) {
        targetSize = CGSizeMake(2*targetSize.width, 2*targetSize.height);
    }
    return [self po_scaledToSize:targetSize];
}

+ (UIImage *)po_getBlurImage:(UIImage *)image blur:(CGFloat)blur {
    
    CGImageRef img = image.CGImage;
    
    return [UIImage po_blurImage:img blur:blur];
}

+ (UIImage *)po_getBlurColor:(UIColor *)color blur:(CGFloat)blur {
    
    UIImage *image = [UIImage po_imageWithColor:color];
    CGImageRef img = image.CGImage;
    
    return [UIImage po_blurImage:img blur:blur];
}

+ (UIImage *)po_blurImage:(CGImageRef )imageRef blur:(CGFloat)blur {
    
    // 模糊度越界
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(imageRef);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(imageRef);
    inBuffer.height = CGImageGetHeight(imageRef);
    inBuffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) *
                         CGImageGetHeight(imageRef));
    
    if (pixelBuffer == NULL) {
#ifdef DEBUG
        NSLog(@"No pixelbuffer");
#endif
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(imageRef);
    outBuffer.height = CGImageGetHeight(imageRef);
    outBuffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
#ifdef DEBUG
        NSLog(@"error from convolution %ld", error);
#endif
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef img = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:img];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(img);
    
    return returnImage;
}

@end
