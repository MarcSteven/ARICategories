//
//  UINavigationItem+Common.m
//
//  Created by Marc Steven on 2022/3/31.
//

#import "UINavigationItem+Common.h"

@implementation UINavigationItem (Common)

- (void)po_lockLeftItem:(BOOL)lock {
    NSArray *leftBarItems = self.leftBarButtonItems;
    if (leftBarItems && [leftBarItems count] > 0) {
        [leftBarItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIBarButtonItem class]] ||
                [obj isMemberOfClass:[UIBarButtonItem class]])
            {
                UIBarButtonItem *barButtonItem = (UIBarButtonItem *)obj;
                barButtonItem.enabled = !lock;
            }
        }];
    }
}

- (void)po_lockRightItem:(BOOL)lock {
    NSArray *rightBarItems = self.rightBarButtonItems;
    if (rightBarItems && [rightBarItems count] > 0) {
        [rightBarItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIBarButtonItem class]] ||
                [obj isMemberOfClass:[UIBarButtonItem class]]) {
                UIBarButtonItem *barButtonItem = (UIBarButtonItem *)obj;
                barButtonItem.enabled = !lock;
            }
        }];
    }
}

@end
