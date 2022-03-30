//
//  NSObject+MSCDescription.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MSCDescription)
@property (nonatomic,readonly) NSString *objectIdentifier;
@property (nonatomic,readonly) NSString *objectName;
@property (nonatomic,readonly) NSString *consoleDesription;
@end

NS_ASSUME_NONNULL_END
