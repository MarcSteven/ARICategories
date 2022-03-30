//
//  UIViewController+SmallScreen.m
//  MemoryChain
//
//  Created by Marc Zhao on 2020/2/10.
//  Copyright © 2020 Memory Chain network technology(China) co,LTD. All rights reserved.
//

#import "UIViewController+SmallScreen.h"


@implementation  UIViewController(SmallScreen)

- (BOOL)smallScreen {
    return CGRectGetWidth(self.view.bounds) <= 480;
}


@end
