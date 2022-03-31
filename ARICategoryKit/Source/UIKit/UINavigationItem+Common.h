//
//  UINavigationItem+Common.h
//
//  Created by Marc Steven on 2022/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationItem (Common)

/**
 左上角的barItem全部锁住
 */
- (void)po_lockLeftItem:(BOOL)lock;

/**
 右上角的barItem全部锁住
 */
- (void)po_lockRightItem:(BOOL)lock;

@end

NS_ASSUME_NONNULL_END
