//
//  NSObject+Copy.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSObject+Copy.h"
#import <objc/runtime.h>

@implementation NSObject (Copy)

- (BOOL)po_copyForShallow:(NSObject *)object {
    Class currentClass = [self class];
    Class instanceClass = [object class];
    
    if (self == object) {
        //相同实例
        return NO;
    }
    
    if (![object isMemberOfClass:currentClass] ) {
        //不是当前类的实例
        return NO;
    }
    
    while (instanceClass != [NSObject class]) {
        unsigned int propertyListCount = 0;
        objc_property_t *propertyList = class_copyPropertyList(currentClass, &propertyListCount);
        for (int i = 0; i < propertyListCount; i++) {
            objc_property_t property = propertyList[i];
            const char *property_name = property_getName(property);
            NSString *propertyName = [NSString stringWithCString:property_name encoding:NSUTF8StringEncoding];
            
            // check if property is dynamic and readwrite
            char *dynamic = property_copyAttributeValue(property, "D");
            char *readonly = property_copyAttributeValue(property, "R");
            if (propertyName && !readonly) {
                id propertyValue = [object valueForKey:propertyName];
                [self setValue:propertyValue forKey:propertyName];
            }
            free(dynamic);
            free(readonly);
        }
        free(propertyList);
        instanceClass = class_getSuperclass(instanceClass);
    }
    
    return YES;
}

#pragma mark -

- (BOOL)po_copyForDeep:(NSObject *)object {
    Class currentClass = [self class];
    Class instanceClass = [object class];
    
    if (self == object) {
        //相同实例
        return NO;
    }
    
    if (![object isMemberOfClass:currentClass] ) {
        //不是当前类的实例
        return NO;
    }
    
    while (instanceClass != [NSObject class]) {
        unsigned int propertyListCount = 0;
        objc_property_t *propertyList = class_copyPropertyList(currentClass, &propertyListCount);
        for (int i = 0; i < propertyListCount; i++) {
            objc_property_t property = propertyList[i];
            const char *property_name = property_getName(property);
            NSString *propertyName = [NSString stringWithCString:property_name encoding:NSUTF8StringEncoding];
            
            // check if property is dynamic and readwrite
            char *dynamic = property_copyAttributeValue(property, "D");
            char *readonly = property_copyAttributeValue(property, "R");
            if (propertyName && !readonly) {
                id propertyValue = [object valueForKey:propertyName];
                Class propertyValueClass = [propertyValue class];
                BOOL flag = [NSObject po_isNSObjectClass:propertyValueClass];
                if (flag) {
                    if ([propertyValue conformsToProtocol:@protocol(NSCopying)]) {
                        NSObject *copyValue = [propertyValue copy];
                        [self setValue:copyValue forKey:propertyName];
                    }
                    else {
                        NSObject *copyValue = [[[propertyValue class]alloc]init];
                        [copyValue po_copyForDeep:propertyValue];
                        [self setValue:copyValue forKey:propertyName];
                    }
                }
                else {
                    [self setValue:propertyValue forKey:propertyName];
                }
            }
            free(dynamic);
            free(readonly);
        }
        free(propertyList);
        instanceClass = class_getSuperclass(instanceClass);
    }
    
    return YES;
}

+ (BOOL)po_isNSObjectClass:(Class)clazz {
    
    BOOL flag = class_conformsToProtocol(clazz, @protocol(NSObject));
    if (flag) {
        return flag;
    }
    else {
        Class superClass = class_getSuperclass(clazz);
        if (!superClass) {
            return NO;
        }
        else {
            return  [NSObject po_isNSObjectClass:superClass];
        }
    }
}

@end
