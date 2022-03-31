//
//  NSObject+GCD.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GCD)

/**
 *  在主线程同步运行block
 *
 *  @param aInMainBlock 被运行的block
 */
+ (void)po_syncInMainThreadBlock:(void(^)(void))aInMainBlock;

/**
 *  在非主线程同步运行block
 *
 *  @param aInThreadBlock 被运行的block
 */
+ (void)po_syncInThreadBlock:(void(^)(void))aInThreadBlock;

/**
 *  在主线程异步运行block
 *
 *  @param aInMainBlock 被运行的block
 */
+ (void)po_performInMainThreadBlock:(void(^)(void))aInMainBlock;

/**
 *  在非主线程异步运行block
 *
 *  @param aInThreadBlock 被运行的block
 */
+ (void)po_performInThreadBlock:(void(^)(void))aInThreadBlock;

/**
 *  延时在主线程运行block
 *
 *  @param aInMainBlock 被运行的block
 *  @param delay        延时时间
 */
+ (void)po_performInMainThreadBlock:(void(^)(void))aInMainBlock afterSecond:(NSTimeInterval)delay;

/**
 *  延时在非主线程运行block
 *
 *  @param aInThreadBlock 被运行的block
 *  @param delay          延时时间
 */
+ (void)po_performInThreadBlock:(void(^)(void))aInThreadBlock afterSecond:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
