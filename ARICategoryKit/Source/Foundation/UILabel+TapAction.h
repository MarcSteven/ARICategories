//
//  UILabel+TapAction.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (TapAction)

/**
 设置 点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL isShowTagEffect;

/**
 在需要对关键字进行监听时使用
 
 @param stringArray           关键字数组
 @param tapActionBlock    点击回调（选中关键字、位置、数组下标）
 */
- (void)po_tapRangeActionWithStringArray:(NSArray <NSString *> *)stringArray
                          tapActionBlock:(void (^) (NSString *string, NSRange range, NSInteger index))tapActionBlock;

@end

NS_ASSUME_NONNULL_END
