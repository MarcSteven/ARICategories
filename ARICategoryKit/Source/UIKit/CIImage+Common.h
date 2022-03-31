//
//  CIImage+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIImage (Common)

/**
 将CIImage转换成UIImage
 */
- (UIImage *)po_imageInterpolatedWithSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
