//
//  UIWindow+MSCSafeArea.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "UIWindow+MSCSafeArea.h"



@implementation UIWindow (MSCSafeArea)
- (UIEdgeInsets)msc_layoutInsets {
    if (@available(iOS 11.0,*)) {
        UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
        if (safeAreaInsets.bottom > 0) {
            return safeAreaInsets;
        }
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
    return UIEdgeInsetsMake(20, 0, 0, 0);
}
- (CGFloat)msc_navigationHeight {
    CGFloat statusBarHeight = [self msc_layoutInsets].top;
    return statusBarHeight + 44;
    
}
@end
