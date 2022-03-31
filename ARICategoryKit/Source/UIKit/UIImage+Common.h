//
//  UIImage+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Common)

/**
 *  PNG image 转 base64
 */
- (NSString *)po_base64EncodedStringForPNG;

/**
 *  JPEG image 转 base64
 */
- (NSString *)po_base64EncodedStringForJPEG;

/**
 *  获取启动页
 */
+ (UIImage *)po_getLaunchImage;

/**
 *  获取app icon
 */
+ (UIImage *)po_getAppIcon;

/**
 *  本地获取图片渲染图
 */
+ (UIImage *)po_imageAlwaysOriginalWithNamed:(NSString *)imageName;

/**
 *  图片渲染
 *
 *  @return 原图色彩
 */
- (UIImage *)po_imageWithRenderingModeAlwaysOriginal;

/**
 *  裁剪图片
 *
 *  @param aRect 裁剪范围
 *
 *  @return 图片
 *
 */
- (UIImage *)po_imageReduceToSize:(CGRect)aRect;

/**
 生成圆角的图片

 @param borderColor 边界色值
 @param borderWidth 边界宽度
 */
- (UIImage *)po_imageCircleForBorderColor:(UIColor *)borderColor
                              borderWidth:(CGFloat)borderWidth;

/**
 图片去色 灰色图片
 */
- (UIImage *)po_grayImage;

/**
 *  @brief  取图片某一点的颜色
 *
 *  @param point 某一点
 *
 *  @return 颜色
 */
- (UIColor *)po_colorWithPoint:(CGPoint)point;

/**
 *  取一个像素的点做图
 *
 *  @param aColor 颜色
 *
 *  @return 纯色图片
 *
 */
+ (UIImage *)po_imageWithColor:(UIColor *)aColor;

/**
 *  获取纯色图片
 *
 *  @param aColor 颜色
 *  @param aFrame 大小
 *
 *  @return 纯色图片
 *
 */
+ (UIImage *)po_imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

/**
 *  最大质量压缩
 *
 *  @param maxFileSize 最大质量
 */
- (UIImage *)po_compressImageToMaxFileSize:(NSInteger)maxFileSize;

/**
 *  给定size图片压缩
 *
 *  @param targetSize 压缩后size
 *
 *  @return 压缩后图片
 *
 */
- (UIImage *)po_scaledToSize:(CGSize)targetSize;

/**
 *  给定size对图片进行高质量压缩
 *
 *  @param targetSize  压缩后size
 *  @param highQuality 是否需要高质量压缩
 *
 *  @return 压缩后图片
 *
 */
- (UIImage *)po_scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;

/**
 根据图片生成一张高斯模糊图片

 @param image 原图
 @param blur  模糊值
 */
+ (UIImage *)po_getBlurImage:(UIImage *)image blur:(CGFloat)blur;

/**
 根据色值生成一张高斯模糊图片
 
 @param color 色值
 @param blur  模糊值
 */
+ (UIImage *)po_getBlurColor:(UIColor *)color blur:(CGFloat)blur;

@end

NS_ASSUME_NONNULL_END
