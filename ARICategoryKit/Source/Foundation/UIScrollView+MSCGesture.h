//
//  UIScrollView+MSCGesture.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/27.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (MSCGesture)
/**
 手势是否禁用
 */
@property (nonatomic,assign) BOOL msc_gestureHandleDisable;

@end

NS_ASSUME_NONNULL_END
