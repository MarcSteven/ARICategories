//
//  NSObject+Copy.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Copy)

/**
 *  浅复制目标的所有属性
 *
 *  @param object 目标对象
 *
 *  @return BOOL—YES:复制成功,NO:复制失败
 */
- (BOOL)po_copyForShallow:(NSObject *)object;

/**
 *  深复制目标的所有属性
 *
 *  @param object 目标对象
 *
 *  @return BOOL—YES:复制成功,NO:复制失败
 */
- (BOOL)po_copyForDeep:(NSObject *)object;

@end

NS_ASSUME_NONNULL_END
