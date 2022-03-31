//
//  NSString+QRCode.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (QRCode)

/**
 *  根据字符串获取二维码图片
 *
 *  @param size   二维码size
 */
- (UIImage *)po_loadQRCodeImageWithSize:(CGFloat)size;

/**
 *  根据字符串生成二维码 并添加logo
 *
 *  @param size     二维码size
 *  @param image    logo图片
 *  @param logoSize logosize
 */
- (UIImage *)po_loadQRCodeImageWithSize:(CGFloat)size
                                 byLogo:(UIImage *)image
                            andLogoSize:(CGFloat)logoSize;

@end

NS_ASSUME_NONNULL_END
