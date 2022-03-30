//
//  UIView+MSCAnimationType.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/29.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MSCAnimationType)
//比例缩小
- (void)animationScaleSmall:(float)scale;
//比例放大
- (void)animationScale:(float)time;
// x 比例放大
- (void)animatinScaleX;
// y 比例放大
- (void)animationY;
//绕中心旋转
- (void)animationFormZ;
//绕x 旋转
- (void)animationFormX;
//绕y 旋转
- (void)animationFormY;
//抖动动画;
- (void)animationShake;
//颜色改变动画 过度
- (void)animationChangeColor;
//动画切换图片
- (void)changeImageAnimatedWithView:(UIImageView *)imageV AndImage:(UIImage *)image;
//动画为view 设置 边线  borderWidth
- (void)animationBorderWidth;
//动画设置阴影
- (void)animationShadowColor;
@end

NS_ASSUME_NONNULL_END
