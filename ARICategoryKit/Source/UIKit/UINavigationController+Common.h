//
//  UINavigationController+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Common)

/**
 *  先pop再push的方法
 *
 *  @param controller 新的控制器
 *  @param animated  是否动画
 */
- (void)po_popAndPushViewController:(UIViewController *)controller
                           animated:(BOOL)animated;

/**
 *  先pop再push的方法
 *
 *  @param controller 新的控制器
 *  @param level  n层
 *  @param animated  是否动画
 */
- (void)po_popAndPushViewController:(UIViewController *)controller
                              level:(NSInteger)level
                           animated:(BOOL)animated;

/**
 *  寻找Navigation中的某个viewcontroler对象
 *
 *  @param className viewcontroler名称
 */
- (id)po_findViewController:(NSString *)className;

/**
 *  返回指定的viewcontroler
 *
 *  @param className 指定viewcontroler类名
 *  @param animated  是否动画
 *
 *  @return pop之后的viewcontrolers
 */
- (NSArray *)po_popToViewControllerWithClassName:(NSString *)className
                                        animated:(BOOL)animated;

/**
 *  pop n层
 *
 *  @param level  n层
 *  @param animated  是否动画
 *
 *  @return pop之后的viewcontrolers
 */
- (NSArray *)po_popToViewControllerWithLevel:(NSInteger)level
                                    animated:(BOOL)animated;

/**
 push动作带动画
 */
- (void)po_pushViewController:(UIViewController *)controller
               withTransition:(UIViewAnimationTransition)transition;

/**
 pop动作带动画
 */
- (UIViewController *)po_popViewControllerWithTransition:(UIViewAnimationTransition)transition;

@end

NS_ASSUME_NONNULL_END
