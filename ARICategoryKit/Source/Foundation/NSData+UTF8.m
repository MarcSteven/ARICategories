//
//  NSData+UTF8.m
//  
//
//  Created by Marc Zhao on 2020/1/14.
//

#import "NSData+UTF8.h"



@implementation NSData (UTF8)
- (NSString *)asUTF8String {
    return [[NSString alloc]initWithData:self encoding:NSUTF8StringEncoding];
    
}

@end
