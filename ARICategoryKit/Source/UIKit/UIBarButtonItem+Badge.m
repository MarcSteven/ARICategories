//
//  UIBarButtonItem+Badge.m
//
//  Created by Marc Zhao on 2022/3/30.
//

#import "UIBarButtonItem+Badge.h"
#import <objc/runtime.h>

NSString const *bar_badgeKey                 = @"bar_badgeKey";

NSString const *bar_badgeBGColorKey          = @"bar_badgeBGColorKey";
NSString const *bar_badgeTextColorKey        = @"bar_badgeTextColorKey";
NSString const *bar_badgeFontKey             = @"bar_badgeFontKey";
NSString const *bar_badgePaddingKey          = @"bar_badgePaddingKey";
NSString const *bar_badgeMinSizeKey          = @"bar_badgeMinSizeKey";
NSString const *bar_badgeOriginXKey          = @"bar_badgeOriginXKey";
NSString const *bar_badgeOriginYKey          = @"bar_badgeOriginYKey";
NSString const *bar_shouldHideBadgeAtZeroKey = @"bar_shouldHideBadgeAtZeroKey";
NSString const *bar_shouldAnimateBadgeKey    = @"bar_shouldAnimateBadgeKey";
NSString const *bar_badgeValueKey            = @"bar_badgeValueKey";

@interface UIBarButtonItem ()

@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation UIBarButtonItem (Badge)

- (void)badgeInit {
    
    UIView *superview = nil;
    CGFloat defaultOriginX = 0;
    if (self.customView) {
        superview = self.customView;
        defaultOriginX = superview.frame.size.width - self.badgeLabel.frame.size.width / 2;
        superview.clipsToBounds = NO;
    }
    else if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        superview = [(id)self view];
        defaultOriginX = superview.frame.size.width - self.badgeLabel.frame.size.width;
    }
    [superview addSubview:self.badgeLabel];
    
    // 初始化，设定默认值
    self.badgeBGColor   = [UIColor redColor];
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeFont      = [UIFont systemFontOfSize:9.0];
    self.badgePadding   = 3;
    self.badgeMinSize   = 8;
    self.badgeOriginX   = defaultOriginX;
    self.badgeOriginY   = 3;
    self.shouldHideBadgeAtZero = YES;
    self.shouldAnimateBadge = YES;
}

#pragma mark - Utility methods

// 当角标的属性改变时，调用此方法
- (void)refreshBadge {
    
    self.badgeLabel.textColor        = self.badgeTextColor;
    self.badgeLabel.backgroundColor  = self.badgeBGColor;
    self.badgeLabel.font             = self.badgeFont;
    
    if (!self.badgeValue
        || [self.badgeValue isEqualToString:@""]
        || ([self.badgeValue isEqualToString:@"0"]
            && self.shouldHideBadgeAtZero)) {
        self.badgeLabel.hidden = YES;
    }
    else {
        self.badgeLabel.hidden = NO;
        [self updateBadgeValueAnimated:YES];
    }
}

- (CGSize)badgeExpectedSize {
    
    UILabel *frameLabel = [self duplicateLabel:self.badgeLabel];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}

// 更新角标
- (void)updateBadgeFrame {
    
    CGSize expectedLabelSize = [self badgeExpectedSize];
    
    CGFloat minHeight = expectedLabelSize.height;
    
    // 判断如果小于最小size，则为最小size
    minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : expectedLabelSize.height;
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.badgePadding;
    
    // 填充边界
    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    self.badgeLabel.frame = CGRectMake(self.badgeOriginX, self.badgeOriginY,
                                       minWidth + padding, minHeight + padding);
    self.badgeLabel.layer.cornerRadius = (minHeight + padding) / 2;
    self.badgeLabel.layer.masksToBounds = YES;
}

// 角标值变化
- (void)updateBadgeValueAnimated:(BOOL)animated {
    // 动画效果
    if (animated && self.shouldAnimateBadge && ![self.badgeLabel.text isEqualToString:self.badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.badgeLabel.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    self.badgeLabel.text = self.badgeValue;
    
    // 动画时间
    if (animated && self.shouldAnimateBadge) {
        [UIView animateWithDuration:0.2 animations:^{
            [self updateBadgeFrame];
        }];
    } else {
        [self updateBadgeFrame];
    }
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy {
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)removeBadge {
    // 移除角标
    [UIView animateWithDuration:0.2 animations:^{
        self.badgeLabel.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.badgeLabel removeFromSuperview];
        self.badgeLabel = nil;
    }];
}

#pragma mark - getters/setters
- (UILabel *)badgeLabel {
    
    UILabel *label = objc_getAssociatedObject(self, &bar_badgeKey);
    if(!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.badgeOriginX, self.badgeOriginY, 15, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self setBadgeLabel:label];
        [self badgeInit];
        [self.customView addSubview:label];
        
    }
    return label;
}

- (void)setBadgeLabel:(UILabel *)badgeLabel {
    objc_setAssociatedObject(self, &bar_badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)badgeValue {
    return objc_getAssociatedObject(self, &bar_badgeValueKey);
}

- (void)setBadgeValue:(NSString *)badgeValue {
    objc_setAssociatedObject(self, &bar_badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self updateBadgeValueAnimated:YES];
    [self refreshBadge];
}

- (UIColor *)badgeBGColor {
    return objc_getAssociatedObject(self, &bar_badgeBGColorKey);
}

- (void)setBadgeBGColor:(UIColor *)badgeBGColor {
    objc_setAssociatedObject(self, &bar_badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badgeLabel) {
        [self refreshBadge];
    }
}

- (UIColor *)badgeTextColor {
    return objc_getAssociatedObject(self, &bar_badgeTextColorKey);
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    objc_setAssociatedObject(self, &bar_badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badgeLabel) {
        [self refreshBadge];
    }
}

- (UIFont *)badgeFont {
    return objc_getAssociatedObject(self, &bar_badgeFontKey);
}
- (void)setBadgeFont:(UIFont *)badgeFont {
    objc_setAssociatedObject(self, &bar_badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badgeLabel) {
        [self refreshBadge];
    }
}

- (CGFloat)badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &bar_badgePaddingKey);
    return number.floatValue;
}

- (void)setBadgePadding:(CGFloat)badgePadding {
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &bar_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badgeLabel) {
        [self updateBadgeFrame];
    }
}

- (CGFloat)badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &bar_badgeMinSizeKey);
    return number.floatValue;
}

- (void)setBadgeMinSize:(CGFloat)badgeMinSize {
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &bar_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badgeLabel) {
        [self updateBadgeFrame];
    }
}

- (CGFloat)badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &bar_badgeOriginXKey);
    return number.floatValue;
}

- (void)setBadgeOriginX:(CGFloat)badgeOriginX {
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &bar_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badgeLabel) {
        [self updateBadgeFrame];
    }
}

- (CGFloat)badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &bar_badgeOriginYKey);
    return number.floatValue;
}

- (void)setBadgeOriginY:(CGFloat)badgeOriginY {
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &bar_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badgeLabel) {
        [self updateBadgeFrame];
    }
}

- (BOOL)shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &bar_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}

- (void)setShouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero {
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &bar_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.badgeLabel) {
        [self refreshBadge];
    }
}

- (BOOL)shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &bar_shouldAnimateBadgeKey);
    return number.boolValue;
}

- (void)setShouldAnimateBadge:(BOOL)shouldAnimateBadge {
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &bar_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.badgeLabel) {
        [self refreshBadge];
    }
}

@end
