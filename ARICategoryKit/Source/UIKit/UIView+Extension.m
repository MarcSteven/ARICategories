//
//  UIView+Extension.m
//  MSKit
//
//  Created by Marc Zhao on 2019/10/24.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "UIView+Extension.h"
#import "NSObject+MSCNameTag.h"
#import "MSCCommon.h"



@implementation UIView (MSSize)
#pragma mark -setter method
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}
-(void)setY:(CGFloat)y {
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


@implementation UIView (AutoLayoutDebugging)
+(void)leftAlignAndVerticallySpaceOutviews:(NSArray *)views distance:(CGFloat)distance {
    for (NSInteger i = 1;i < views.count ; i ++) {
        UIView *firstView = views[i -1];
        UIView *secondView = views[i];
        firstView.translatesAutoresizingMaskIntoConstraints = NO;
        secondView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeTop multiplier:1 constant:distance];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        [firstView.superview addConstraints:@[constraint1,constraint2]];
        
    }
}
- (void)exerciseAmbiguityInLayoutRepeatedly:(BOOL)recursive {
    #ifdef DEBUG
        if(self.hasAmbiguousLayout) {
            [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(exerciseAmbiguityInLayout) userInfo:nil repeats:YES];
        }
        if(recursive) {
            for(UIView *subview in self.subviews) {
                [subview exerciseAmbiguityInLayoutRepeatedly:YES];
            }
            
        }
    #endif
}
@end


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





@implementation UIView (MSCNamedConstraintSupport)
- (NSLayoutConstraint *)constraintNamed:(NSString *)aName {
    if (!aName) {
        return nil;
    }
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.nameTag && [constraint.nameTag isEqualToString:aName]) {
            return constraint;
        }
        
    }
    if (self.superview) {
        return [self.superview constraintNamed:aName];
    }
    return nil;
}
- (NSLayoutConstraint *)constraintNamed:(NSString *)aName matchingView:(UIView *)theView {
    if(!aName ) return nil;
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.nameTag && [constraint.nameTag isEqualToString:aName]) {
            if(constraint.firstItem == theView) return constraint;
            if (constraint.secondItem && constraint.secondItem == theView) return constraint;
        }
        if (self.superview) return [self.superview constraintNamed:aName matchingView:theView];
    }
    return nil;
}
-(NSArray *)constraintsNamed:(NSString *)aName {
    //for this ,all constraints match a nil item
    if (!aName) return self.constraints;
    //Howerve, constraints have to have a name to match a non-nil name
    NSMutableArray *array = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in self.constraints)
        if (constraint.nameTag && [constraint.nameTag isEqualToString:aName])
            [array addObject:constraint];
           // recurse upwords
    if (self.superview) {
        [array addObjectsFromArray:[self.superview constraintsNamed:aName]];
    }
    return array;
        
    
}

@end
