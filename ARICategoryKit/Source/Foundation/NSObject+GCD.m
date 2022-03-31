//
//  NSObject+GCD.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSObject+GCD.h"

@implementation NSObject (GCD)

+ (void)po_syncInMainThreadBlock:(void(^)(void))aInMainBlock {
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        aInMainBlock();
    });
}

+ (void)po_syncInThreadBlock:(void(^)(void))aInThreadBlock {
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        aInThreadBlock();
    });
}

+ (void)po_performInMainThreadBlock:(void(^)(void))aInMainBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        aInMainBlock();
    });
}

+ (void)po_performInThreadBlock:(void(^)(void))aInThreadBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        aInThreadBlock();
    });
}

+ (void)po_performInMainThreadBlock:(void(^)(void))aInMainBlock afterSecond:(NSTimeInterval)delay {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        aInMainBlock();
    });
}

+ (void)po_performInThreadBlock:(void(^)(void))aInThreadBlock afterSecond:(NSTimeInterval)delay {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        aInThreadBlock();
    });
}

@end
