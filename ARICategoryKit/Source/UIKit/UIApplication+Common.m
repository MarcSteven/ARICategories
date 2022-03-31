//
//  UIApplication+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "UIApplication+Common.h"

@implementation UIApplication (Common)

#pragma mark - keyboardFrame

static CGRect _po_keyboardFrame = (CGRect){ (CGPoint){ 0.0f, 0.0f }, (CGSize){ 0.0f, 0.0f } };

+ (void)load {
    
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        _po_keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
     }];
    
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardDidChangeFrameNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        _po_keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
     }];
    
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardDidHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        _po_keyboardFrame = CGRectZero;
     }];
}

- (CGRect)po_keyboardFrame {
    return _po_keyboardFrame;
}

@end
