//
//  NSString+QRCode.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSString+QRCode.h"

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
