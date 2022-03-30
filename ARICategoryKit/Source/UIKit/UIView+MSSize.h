//
//  UIView+MSSize.h
//  MSKit
//
//  Created by Marc Zhao on 2019/10/24.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MSSize)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGPoint origin;


@end

NS_ASSUME_NONNULL_END
