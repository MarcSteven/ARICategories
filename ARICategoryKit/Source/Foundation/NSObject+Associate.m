//
//  NSObject+Associate.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/4.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "NSObject+Associate.h"

#import <objc/runtime.h>

@implementation NSObject (Associate)
@dynamic associatedObject;
- (void)setAssociatedObject:(id)object {
    objc_setAssociatedObject(self, @selector(associatedObject),object , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)associatedObject {
    return objc_getAssociatedObject(self, @selector(associatedObject));
}
@end
