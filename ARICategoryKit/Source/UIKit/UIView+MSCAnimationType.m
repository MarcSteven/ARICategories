//
//  UIView+MSCAnimationType.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/29.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "UIView+MSCAnimationType.h"



@implementation UIView (MSCAnimationType)
//比例缩小
- (void)animationScaleSmall:(float)scale{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima.toValue = [NSNumber numberWithFloat:scale];
    anima.duration = 0.f;
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    [self.layer addAnimation:anima forKey:@"scaleAnimation"];
}
//比例放大
- (void)animationScale:(float)time{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima.toValue = [NSNumber numberWithFloat:2.0f];
    anima.duration = time;
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    [self.layer addAnimation:anima forKey:@"scaleAnimation"];
}
// x 比例放大
- (void)animatinScaleX{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];//同上
    anima.toValue = [NSNumber numberWithFloat:2.0f];
    anima.duration = 1.0f;
    [self.layer addAnimation:anima forKey:@"scaleAnimationX"];
}
// y 比例放大
- (void)animationY{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];//同上
    anima.toValue = [NSNumber numberWithFloat:2.0f];
    anima.duration = 1.0f;
    [self.layer addAnimation:anima forKey:@"scaleAnimationY"];
}
//绕中心旋转
- (void)animationFormZ{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    anima.toValue = [NSNumber numberWithFloat:M_PI*2];
    anima.duration = 2.0f;
    [self.layer addAnimation:anima forKey:@"rotateAnimation"];
}
//绕x 旋转
- (void)animationFormX{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    anima.toValue = [NSNumber numberWithFloat:M_PI*2];
    anima.duration = 2.0f;
    [self.layer addAnimation:anima forKey:@"rotateAnimation"];
}
//绕y 旋转
- (void)animationFormY{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    anima.toValue = [NSNumber numberWithFloat:M_PI*2];
    anima.duration = 2.0f;
    [self.layer addAnimation:anima forKey:@"rotateAnimation"];
}
//抖动动画
- (void)animationShake{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];//在这里@"transform.rotation"==@"transform.rotation.z"
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*4];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*4];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*4];
    anima.values = @[value1,value2,value3];
    anima.repeatCount = 15;
    
    [self.layer addAnimation:anima forKey:@"shakeAnimation"];
}
//颜色改变动画 过度
- (void)animationChangeColor{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anima.toValue =(id) [UIColor greenColor].CGColor;
    anima.duration = 2.0f;
    //如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    //anima.fillMode = kCAFillModeForwards;
    //anima.removedOnCompletion = NO;
    [self.layer addAnimation:anima forKey:@"backgroundAnimation"];
}
//动画切换图片
- (void)changeImageAnimatedWithView:(UIImageView *)imageV AndImage:(UIImage *)image {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [imageV.layer addAnimation:transition forKey:@"a"];
    [imageV setImage:image];
    
}
//动画为view 设置 边线  borderWidth
- (void)animationBorderWidth{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    anima.toValue = [NSNumber numberWithFloat:1.0f];
    anima.duration = 1.0f;
    //如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    [self.layer addAnimation:anima forKey:@"borderWidth"];
}
//动画设置阴影
- (void)animationShadowColor{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"shadowColor"];
    anima.toValue =(id) [UIColor blackColor].CGColor;
    anima.duration = 1.0f;
    //如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    [self.layer addAnimation:anima forKey:@"shadowColor"];
}
@end
