//
//  UIImageView+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Common)

/**
 添加倒影
 */
- (void)po_addReflect;

/**
 启动数组轮播图片
 */
- (void)po_showGifAnimationImages:(NSArray *)animationImages;

/**
 停止数组轮播图片
 */
- (void)po_stopGifAnimating;

@end

NS_ASSUME_NONNULL_END
