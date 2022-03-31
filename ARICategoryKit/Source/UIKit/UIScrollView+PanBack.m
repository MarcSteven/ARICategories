//
//  UIScrollView+PanBack.m
//
//  Created by Marc Steven on 2022/3/31.
//

#import "UIScrollView+PanBack.h"

@implementation UIScrollView (PanBack)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [self panBack:gestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return ![self panBack:gestureRecognizer];
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    
    int locationX = 0.15 * [UIScreen mainScreen].bounds.size.width;
    
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            
            CGPoint location = [gestureRecognizer locationInView:self];
            
            // 允许每张page都可实现滑动返回
//            int location1 = location.x;
//            int location2 = [UIScreen mainScreen].bounds.size.width;
//            NSInteger XX = location1 % location2;
//            if (point.x > 0 && XX < locationX) {
//                return YES;
//            }
            
            // 只允许在第一张时滑动返回生效
            
            if (point.x > 0 && location.x < locationX && self.contentOffset.x <= 0) {
                return YES;
            }
        }
    }
    return NO;
}

@end
