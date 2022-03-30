//
//  NSObject+MSCNameTag.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "NSObject+MSCNameTag.h"

#import <objc/runtime.h>
static const char nametag_key;


@implementation NSObject (MSCNameTag)

- (void)setNameTag:(NSString *)nameTag {
    objc_setAssociatedObject(self, (void *)&nametag_key, nameTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)nameTag {
    return objc_getAssociatedObject(self, (void *)&nametag_key);
}
@end
