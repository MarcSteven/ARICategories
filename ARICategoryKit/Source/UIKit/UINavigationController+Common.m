//
//  UINavigationController+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "UINavigationController+Common.h"

@implementation UINavigationController (Common)

- (void)po_popAndPushViewController:(UIViewController *)controller
                           animated:(BOOL)animated {
    
    NSMutableArray *viewControllersArray = [self.viewControllers mutableCopy];
    
    if (viewControllersArray.count > 1) {
        [viewControllersArray removeLastObject];
        [viewControllersArray addObject:controller];
        
        if (viewControllersArray.count == 2) {
            controller.hidesBottomBarWhenPushed = YES;
        }
        
        [self setViewControllers:viewControllersArray animated:animated];
    }
    else {
        [self pushViewController:controller animated:animated];
    }
}

- (void)po_popAndPushViewController:(UIViewController *)controller
                              level:(NSInteger)level
                           animated:(BOOL)animated {
    
    NSMutableArray *viewControllersArray = [self.viewControllers mutableCopy];
    
    if (viewControllersArray.count > level) {
        [viewControllersArray removeObjectsInRange:NSMakeRange(viewControllersArray.count -level, level)];
        [viewControllersArray addObject:controller];
        
        if (viewControllersArray.count == 2) {
            controller.hidesBottomBarWhenPushed = YES;
        }
        
        [self setViewControllers:viewControllersArray animated:animated];
    }
    else if (viewControllersArray.count == 1){
        [self pushViewController:controller animated:animated];
    }
    else {
        [viewControllersArray removeObjectsInRange:NSMakeRange(1, viewControllersArray.count -1 )];
        [viewControllersArray addObject:controller];
        
        if (viewControllersArray.count == 2) {
            controller.hidesBottomBarWhenPushed = YES;
        }
        
        [self setViewControllers:viewControllersArray animated:animated];
    }
}

- (id)po_findViewController:(NSString *)className {
    
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            return viewController;
        }
    }
    
    return nil;
}

- (NSArray *)po_popToViewControllerWithClassName:(NSString *)className
                                        animated:(BOOL)animated {
    return [self popToViewController:[self po_findViewController:className] animated:YES];
}

- (NSArray *)po_popToViewControllerWithLevel:(NSInteger)level
                                    animated:(BOOL)animated {
    
    NSInteger viewControllersCount = self.viewControllers.count;
    if (viewControllersCount > level) {
        NSInteger index = viewControllersCount - level - 1;
        UIViewController *viewController = self.viewControllers[index];
        
        return [self popToViewController:viewController animated:animated];
    }
    else {
        return [self popToRootViewControllerAnimated:animated];
    }
}

- (void)po_pushViewController:(UIViewController *)controller
               withTransition:(UIViewAnimationTransition)transition {
    
    [UIView beginAnimations:nil context:NULL];
    [self pushViewController:controller animated:NO];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (UIViewController *)po_popViewControllerWithTransition:(UIViewAnimationTransition)transition {
    
    [UIView beginAnimations:nil context:NULL];
    UIViewController *controller = [self popViewControllerAnimated:NO];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
    return controller;
}

@end
