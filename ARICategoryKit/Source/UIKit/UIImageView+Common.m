//
//  UIImageView+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "UIImageView+Common.h"

@implementation UIImageView (Common)

- (void)po_addReflect {
    
    CGRect frame = self.frame;
    frame.origin.y += (frame.size.height + 1);
    
    UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
    self.clipsToBounds = YES;
    reflectionImageView.contentMode = self.contentMode;
    [reflectionImageView setImage:self.image];
    reflectionImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    CALayer *reflectionLayer = [reflectionImageView layer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor blueColor] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] CGColor], nil];
    
    gradientLayer.startPoint = CGPointMake(0.5,0.5);
    gradientLayer.endPoint = CGPointMake(0.5,1.0);
    reflectionLayer.mask = gradientLayer;
    
    [self.superview addSubview:reflectionImageView];
    
}

#pragma mark - 轮播 Gif

- (void)po_showGifAnimationImages:(NSArray *)animationImages {
    
    if (!animationImages.count) {
        return;
    }
    
    self.animationImages = animationImages;
    self.animationDuration = 0.5;
    self.animationRepeatCount = 0;
    
    [self startAnimating];
}

- (void)po_stopGifAnimating {
    if (self.isAnimating) {
        [self stopAnimating];
    }
    
    [self removeFromSuperview];
}

@end
