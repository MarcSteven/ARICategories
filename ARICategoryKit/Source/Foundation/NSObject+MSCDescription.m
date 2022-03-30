//
//  NSObject+MSCDescription.m
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//

#import "NSObject+MSCDescription.h"
#import "NSObject+MSCNameTag.h"




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
