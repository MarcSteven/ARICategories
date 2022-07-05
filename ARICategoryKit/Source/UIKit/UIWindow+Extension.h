//
//  UIWindow+MSCSafeArea.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (MSCSafeArea)

/// layout insets
- (UIEdgeInsets)msc_layoutInsets;

/// navigation height
- (CGFloat)msc_navigationHeight;
@end

NS_ASSUME_NONNULL_END
