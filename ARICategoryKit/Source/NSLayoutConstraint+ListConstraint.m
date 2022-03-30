//
//  NSLayoutConstraint+ListConstraint.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/3.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//

#import "NSLayoutConstraint+ListConstraint.h"



@implementation NSLayoutConstraint (ListConstraint)
+ (void)listConstraint:(UIView *)v {
    if (v == nil) {
        v = [[UIApplication sharedApplication]keyWindow];
               for (UIView *vv in v.subviews) {
                   NSArray *array1 = [vv constraintsAffectingLayoutForAxis:0];
                   NSArray *array2 = [vv constraintsAffectingLayoutForAxis:1];
                   NSLog(@"%@\nH:%@\nV:%@",vv,array1,array2);
                   if(vv.subviews.count){
                       [self listConstraint:vv];
            
        }
        }
    }
    
}
@end
