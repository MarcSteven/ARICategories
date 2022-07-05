//
//  NSLayoutConstraint+ViewHierarchy.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/26.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "NSLayoutConstraint+ViewHierarchy.h"



@implementation NSLayoutConstraint (ViewHierarchy)
/**
 cast the first item to a view
 */
- (UIView *)firstView {
    return self.firstItem;
}
/**
 cast the second item to a view
 */
- (UIView *)secondView {
    return self.secondItem;
    
}
- (BOOL)isUnary {
    return self.secondItem == nil;
}
- (UIView *)likelyOwner {
    if (self.isUnary) {
        return self.firstView;
    }
    return  self.firstView;
}
//- (NSArray *)supervies {
//    NSMutableArray *array = [NSMutableArray array];
//    
//}
//- (NSArray *)superviews {
//    NSMutableArray *array = [NSMutableArray array];
//   // UIView *view = select(<#int#>, <#fd_set *restrict#>, <#fd_set *restrict#>, <#fd_set *restrict#>, <#struct timeval *restrict#>)
//}
//- (UIView *)likelyOwner {
//    if (self.isUnary) {
//        return self.firstView;
//    }
//    return [self.firstView ]
//}
/**
 return an array of all superviews
 */
//- (NSArray *)superviews {
//    NSMutableArray *array = [NSMutableArray array];
//    //UIView *view = self.superview;
//    while (view) {
//        [array addObject:view];
//        view = view.superview;
//    }
//}
//- (BOOL)isAncestorOfView:(UIView *)aView {
//    return [aView superviews] 
//}
@end
