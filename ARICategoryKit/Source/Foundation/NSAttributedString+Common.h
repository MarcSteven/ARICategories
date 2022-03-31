//
//  NSAttributedString+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>
@class UIColor;

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Common)

/**
 对内容中部份关键字进行着色处理
 
 @param content      内容
 @param searchKey    关键字
 @param keyWordColor 关键字颜色
 
 @return 富文本
 */
+ (NSAttributedString *)po_attributeStringWithContent:(NSString *)content
                                            searchKey:(NSString *)searchKey
                                      forKeyWordColor:(UIColor *)keyWordColor;

/**
 适配富文本内容高度

 @param width 包含的最大宽
 @return 内容高值
 */
- (float)po_heightWithContainWidth:(float)width;

@end

NS_ASSUME_NONNULL_END
