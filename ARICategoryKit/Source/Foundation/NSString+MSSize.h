//
//  NSString+MSSize.h
//  MSKit
//
//  Created by Marc Zhao on 2019/10/24.
//  Copyright © 2019 Marc Zhao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MSSize)
-(CGFloat)ms_widthOfFont:(UIFont *)font;

-(CGFloat)ms_heightOfFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
