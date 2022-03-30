//
//  UITableView+ReloadAnimation.m
//
//  Created by Marc Zhao on 2022/3/30.
//

#import "UITableView+ReloadAnimation.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UITableView (ReloadAnimation)

- (void)ari_reloadDataWithAnimationType:(ARITableViewAnimationType)animationType {
    
    [self reloadData];
    
    [UITableView showWithAnimationType:animationType tableView:self];
}

#pragma mark - private

+ (void)showWithAnimationType:(ARITableViewAnimationType)animationType
                    tableView:(UITableView *)tableView {
    
    unsigned int count = 0;
    
    Method *methodlist = class_copyMethodList(object_getClass(self.class), &count);
    
    int tag = 0;
    for (int i = 0; i < count; ++i) {
        Method method = methodlist[i];
        SEL selector = method_getName(method);
        NSString *methodName = NSStringFromSelector(selector);
        
        if ([methodName rangeOfString:@"AnimationWithTableView"].location != NSNotFound) {
            
            if (tag == animationType) {
                ((void (*)(id,SEL,UITableView *))objc_msgSend)(self,selector,tableView);
                break;
            }
            tag++;
        }
    }
    free(methodlist);
}

#pragma mark -

+ (void)moveAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    CGFloat totalTime = 0.4;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        cell.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0);
        
        [UIView animateWithDuration:0.4
                              delay:i * (totalTime / cellArr.count)
             usingSpringWithDamping:0.7
              initialSpringVelocity:1 / 0.7
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             cell.transform = CGAffineTransformIdentity;
                             
                         } completion:nil];
    }
}

+ (void)alphaAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        cell.alpha = 0.0;
        
        [UIView animateWithDuration:0.3
                              delay:i * 0.05
                            options:0
                         animations:^{
                             
                             cell.alpha = 1.0;
                             
                         } completion:nil];
    }
}

+ (void)fallAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    NSTimeInterval totalTime = 0.8;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        cell.transform = CGAffineTransformMakeTranslation(0, -[UIScreen mainScreen].bounds.size.height);
        
        [UIView animateWithDuration:0.3
                              delay:(cellArr.count - i) * (totalTime / cellArr.count)
                            options:0
                         animations:^{
                             
                             cell.transform = CGAffineTransformIdentity;
                             
                         } completion:nil];
    }
}


+ (void)shakeAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        
        if (i%2 == 0) {
            cell.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0);
        }
        else {
            cell.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        }
        
        [UIView animateWithDuration:0.4
                              delay:i * 0.03
             usingSpringWithDamping:0.75
              initialSpringVelocity:1 / 0.75
                            options:0
                         animations:^{
                             
                             cell.transform = CGAffineTransformIdentity;
                             
                         } completion:nil];
    }
}

+ (void)overTurnAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    NSTimeInterval totalTime = 0.7;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        cell.layer.opacity = 0.0;
        cell.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        
        [UIView animateWithDuration:0.3
                              delay:i * (totalTime / cellArr.count)
                            options:0
                         animations:^{
                             
                             cell.layer.opacity = 1.0;
                             cell.layer.transform = CATransform3DIdentity;
                             
                         } completion:nil];
    }
}

+ (void)toTopAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    NSTimeInterval totalTime = 0.8;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        cell.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
        
        [UIView animateWithDuration:0.35
                              delay:i * (totalTime / cellArr.count)
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             cell.transform = CGAffineTransformIdentity;
                             
                         } completion:nil];
    }
}

+ (void)springListAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    NSTimeInterval totalTime = 1.0;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        cell.layer.opacity = 0.7;
        cell.layer.transform = CATransform3DMakeTranslation(0, -[UIScreen mainScreen].bounds.size.height, 20);
        
        [UIView animateWithDuration:0.4
                              delay:i * (totalTime / cellArr.count)
             usingSpringWithDamping:0.65
              initialSpringVelocity:1 / 0.65
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             cell.layer.opacity = 1.0;
                             cell.layer.transform = CATransform3DMakeTranslation(0, 0, 20);
                             
                         } completion:nil];
    }
}

+ (void)shrinkToTopAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        CGRect rect = [cell convertRect:cell.bounds fromView:tableView];
        cell.transform = CGAffineTransformMakeTranslation(0, -rect.origin.y);
        
        [UIView animateWithDuration:0.5 animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
    }
}

+ (void)layDownAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    NSMutableArray *rectArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        CGRect rect = cell.frame;
        
        [rectArr addObject:[NSValue valueWithCGRect:rect]];
        
        rect.origin.y = i * 10;
        cell.frame = rect;
        cell.layer.transform = CATransform3DMakeTranslation(0, 0, i*5);
    }
    
    NSTimeInterval totalTime = 0.8;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        CGRect rect = [rectArr[i] CGRectValue];
        
        [UIView animateWithDuration:(totalTime / cellArr.count) * i
                         animations:^{
                             
                             cell.frame = rect;
                             
                         } completion:^(BOOL finished) {
                             cell.layer.transform = CATransform3DIdentity;
                         }];
    }
}

+ (void)roteAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cellArr = tableView.visibleCells;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @(-M_PI);
    animation.toValue = 0;
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 3;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    
    for (int i = 0; i < cellArr.count; ++i) {
        
        UITableViewCell *cell = cellArr[i];
        cell.alpha = 0.0;
        
        [UIView animateWithDuration:0.1
                              delay:i * 0.25
                            options:0
                         animations:^{
                             
                             cell.alpha = 1.0;
                             
                         } completion:^(BOOL finished) {
                             [cell.layer addAnimation:animation forKey:@"rotationYkey"];
                         }];
    }
}

@end
