//
//  NSObject+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSObject+Common.h"
#import <objc/runtime.h>

@implementation NSObject (Common)

+ (UIViewController *)po_getWindowViewController {
    
    for (UIWindow *window in [UIApplication sharedApplication].windows.reverseObjectEnumerator) {
        
        UIView *tempView = window.subviews.lastObject;
        
        for (UIView *subview in window.subviews.reverseObjectEnumerator) {
            if ([subview isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
                tempView = subview;
                break;
            }
        }
        
        BOOL(^canNext)(UIResponder *) = ^(UIResponder *responder) {
            if (![responder isKindOfClass:[UIViewController class]]) {
                return YES;
            }
            else if ([responder isKindOfClass:[UINavigationController class]]) {
                return YES;
            }
            else if ([responder isKindOfClass:[UITabBarController class]]) {
                return YES;
            }
            else if ([responder isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
                return YES;
            }
            return NO;
        };
        
        UIResponder *nextResponder = tempView.nextResponder;
        
        while (canNext(nextResponder)) {
            tempView = tempView.subviews.firstObject;
            if (!tempView) {
                return nil;
            }
            nextResponder = tempView.nextResponder;
        }
        
        UIViewController *currentVC = (UIViewController *)nextResponder;
        if (currentVC) {
            return currentVC;
        }
    }
    return nil;
}

+ (UIViewController *)po_getDisplayViewController {
    
    // 定义一个变量存放当前屏幕显示的viewcontroller
    UIViewController *result = nil;
    
    // 得到当前应用程序的主要窗口
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    // windowLevel是在 Z轴 方向上的窗口位置，默认值为UIWindowLevelNormal
    if (window.windowLevel != UIWindowLevelNormal) {
        // 获取应用程序所有的窗口
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            // 找到程序的默认窗口（正在显示的窗口）
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                // 将关键窗口赋值为默认窗口
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获取窗口的当前显示视图
    UIView *frontView = [[window subviews] firstObject];
    
    // 获取视图的下一个响应者，UIView视图调用这个方法的返回值为UIViewController或它的父视图
    id nextResponder = [frontView nextResponder];
    
    // 判断显示视图的下一个响应者是否为一个UIViewController的类对象
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    
    return result;
}

@end


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
@implementation NSObject (MSCHelper)
- (NSString *)msc_className {
    return NSStringFromClass([self class]);
    

}

@end

@implementation NSObject (MSCDescription)
- (NSString *)objectIdentifier {
    return [NSString stringWithFormat:@"%@:0x%0x",self.class.description,(int)self];
}
- (NSString *)objectName {
    if (self.nameTag) {
        return [NSString stringWithFormat:@"%@:0x%0x",self.nameTag,(int)self];
    }
    return [NSString stringWithFormat:@"%@",self.objectIdentifier];
}
NSString *consoleString(NSString *string,NSInteger maxLength,NSInteger indent) {
    //Build spacer

    NSMutableString *spacer = [NSMutableString stringWithString:@"\n"];
    for (int i = 0; i < indent; i++)
        [spacer appendString:@" "];
    
    // Decompose into space-separated items
    NSArray *wordArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSInteger wordCount = wordArray.count;
    NSInteger index = 0;
    NSInteger lengthOfNextWord = 0;
    
    // Perform decomposition
    NSMutableArray *array = [NSMutableArray array];
    while (index < wordCount)
    {
        NSMutableString *line = [NSMutableString string];
        while (((line.length + lengthOfNextWord + 1) <= maxLength) &&
               (index < wordCount))
        {
            lengthOfNextWord = [wordArray[index] length];
            [line appendString:wordArray[index]];
            if (++index < wordCount)
                [line appendString:@" "];
        }
        [array addObject:line];
    }
    
    return [array componentsJoinedByString:spacer];

}
//wrapped description
- (NSString *)consoleDesription {
    return consoleString(self.description, 80, 8);
    
}
@end



#import <objc/runtime.h>
static const char nametag_key;


@implementation NSObject (MSCNameTag)

- (void)setNameTag:(NSString *)nameTag {
    objc_setAssociatedObject(self, (void *)&nametag_key, nameTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)nameTag {
    return objc_getAssociatedObject(self, (void *)&nametag_key);
}
@end


@implementation NSObject (Associate)
@dynamic associatedObject;
- (void)setAssociatedObject:(id)object {
    objc_setAssociatedObject(self, @selector(associatedObject),object , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)associatedObject {
    return objc_getAssociatedObject(self, @selector(associatedObject));
}
@end


@implementation NSObject (GCD)

+ (void)po_syncInMainThreadBlock:(void(^)(void))aInMainBlock {
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        aInMainBlock();
    });
}

+ (void)po_syncInThreadBlock:(void(^)(void))aInThreadBlock {
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        aInThreadBlock();
    });
}

+ (void)po_performInMainThreadBlock:(void(^)(void))aInMainBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        aInMainBlock();
    });
}

+ (void)po_performInThreadBlock:(void(^)(void))aInThreadBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        aInThreadBlock();
    });
}

+ (void)po_performInMainThreadBlock:(void(^)(void))aInMainBlock afterSecond:(NSTimeInterval)delay {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        aInMainBlock();
    });
}

+ (void)po_performInThreadBlock:(void(^)(void))aInThreadBlock afterSecond:(NSTimeInterval)delay {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        aInThreadBlock();
    });
}

@end
