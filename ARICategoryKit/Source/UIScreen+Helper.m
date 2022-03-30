//
//  UIScreen+Helper.m
//  MSNetworkKit
//
//  Created by Marc Zhao on 2020/2/12.
//  Copyright © 2020 Memory Chain network technology(Shenzhen) Co,LTD. All rights reserved.
//

#import "UIScreen+Helper.h"


@implementation UIScreen (Helper)
- (CGFloat)screenWidth {
    return UIScreen.mainScreen.bounds.size.width;
    
}
- (CGFloat)screenHeight {
    return UIScreen.mainScreen.bounds.size.height;
}

@end
