//
//  UITableView+ReloadAnimation.h
//
//  Created by Marc Zhao on 2022/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ARITableViewAnimationType) {
    ARITableViewAnimationTypeMove = 0,
    ARITableViewAnimationTypeAlpha,
    ARITableViewAnimationTypeFall,
    ARITableViewAnimationTypeShake,
    ARITableViewAnimationTypeOverTurn,
    ARITableViewAnimationTypeToTop,
    ARITableViewAnimationTypeSpringList,
    ARITableViewAnimationTypeShrinkToTop,
    ARITableViewAnimationTypeLayDown,
    ARITableViewAnimationTypeRote,
};

@interface UITableView (ReloadAnimation)

/**
 reloadData 并附带cell动画

 @param animationType 动画类型
 */
- (void)ari_reloadDataWithAnimationType:(ARITableViewAnimationType)animationType;

@end

NS_ASSUME_NONNULL_END
