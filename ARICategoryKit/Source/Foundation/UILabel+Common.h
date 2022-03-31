//
//  UILabel+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Common)

/**
 字间距
 */
@property (nonatomic, assign) CGFloat characterSpace;

/**
 行间距
 */
@property (nonatomic, assign) CGFloat lineSpace;

/**
 关键字数组
 */
@property (nonatomic, strong) NSArray<NSString *> *keywordsArr;

/**
 关键字
 */
@property (nonatomic, strong) NSString *keywords;

/**
 关键字字体
 */
@property (nonatomic, strong) UIFont *keywordsFont;

/**
 关键字色值
 */
@property (nonatomic, strong) UIColor *keywordsColor;

/**
 需要画下划线的文本
 */
@property (nonatomic, strong) NSString *underlineStr;

/**
 下划线色值
 */
@property (nonatomic, strong) UIColor *underlineColor;

/**
 获取label行数
 */
- (NSInteger)getSeparatedLinesFromLabel;

@end

NS_ASSUME_NONNULL_END
