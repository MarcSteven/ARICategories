//
//  MSCCommon.h
//  MSKit
//
//  Created by Marc Zhao on 2019/11/28.
//  Copyright © 2019 Memory Chain network technology (Shenzhen) co. LTD. All rights reserved.
//


#ifndef MSCCommon_h
#define MSCCommon_h
#endif

#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


#pragma mark - Cross Platform



#define VIEW_CLASS UIView
#define COLOR_CLASS UIColor
#define IMAGE_CLASS UIImage
#import "NSObject+MSCNameTag.h"
// Constraint Matching, Retrieval



// Constraint Description for Debugging
#import "NSObject+MSCDescription.h"



#pragma mark - Testing Constraint Elements

#define IS_SIZE_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeWidth), @(NSLayoutAttributeHeight)] containsObject:@(ATTRIBUTE)]
#define IS_CENTER_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeCenterX), @(NSLayoutAttributeCenterY)] containsObject:@(ATTRIBUTE)]
#define IS_EDGE_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeLeft), @(NSLayoutAttributeRight), @(NSLayoutAttributeTop), @(NSLayoutAttributeBottom), @(NSLayoutAttributeLeading), @(NSLayoutAttributeTrailing), @(NSLayoutAttributeBaseline)] containsObject:@(ATTRIBUTE)]
#define IS_LOCATION_ATTRIBUTE(ATTRIBUTE) (IS_EDGE_ATTRIBUTE(ATTRIBUTE) || IS_CENTER_ATTRIBUTE(ATTRIBUTE))

#define IS_HORIZONTAL_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeLeft), @(NSLayoutAttributeRight), @(NSLayoutAttributeLeading), @(NSLayoutAttributeTrailing), @(NSLayoutAttributeCenterX), @(NSLayoutAttributeWidth)] containsObject:@(ATTRIBUTE)]
#define IS_VERTICAL_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeTop), @(NSLayoutAttributeBottom), @(NSLayoutAttributeCenterY), @(NSLayoutAttributeHeight), @(NSLayoutAttributeBaseline)] containsObject:@(ATTRIBUTE)]

#define IS_HORIZONTAL_ALIGNMENT(ALIGNMENT) [@[@(NSLayoutFormatAlignAllLeft), @(NSLayoutFormatAlignAllRight), @(NSLayoutFormatAlignAllLeading), @(NSLayoutFormatAlignAllTrailing), @(NSLayoutFormatAlignAllCenterX), ] containsObject:@(ALIGNMENT)]
#define IS_VERTICAL_ALIGNMENT(ALIGNMENT) [@[@(NSLayoutFormatAlignAllTop), @(NSLayoutFormatAlignAllBottom), @(NSLayoutFormatAlignAllCenterY), @(NSLayoutFormatAlignAllBaseline), ] containsObject:@(ALIGNMENT)]
// Custom Colors for my own use
#if TARGET_OS_IPHONE
    #define ORANGE_COLOR    [UIColor colorWithRed:1.0f green:0.6f blue:0.0f alpha:1.0f]
    #define AQUA_COLOR      [UIColor colorWithRed:0.0f green:.6745 blue:.8039 alpha:1.0f]
    #define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#elif TARGET_OS_MAC
    #define ORANGE_COLOR    [NSColor colorWithDeviceRed:1 green:0.6 blue:0 alpha:1]
    #define AQUA_COLOR    [NSColor colorWithDeviceRed:0 green:0.6745 blue:0.8039 alpha:1]
    #define COOKBOOK_PURPLE_COLOR [NSColor colorWithDeviceRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#endif

#define RECTCENTER(_rect_) CGPointMake(CGRectGetMidX(_rect_), CGRectGetMidY(_rect_))

// Other utilities
#if TARGET_OS_IPHONE
    #define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    #define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    #define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#elif TARGET_OS_MAC

#define MSCDeviceVersion [[UIDevice currentDevice] systemVersion] floatValue];

#define MSC_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MSC_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MSC_SAFEAREA_TOP (MSC_IS_iPhoneX ? 24.0f: 0.0f) //
#define MSC_SAFEAREA_BOTTOM (MSC_IS_iPhoneX? 34.0f : 0.0f)
#define MSC_STATUSBAR_HEIGHT (MSC_IS_iPhoneX? 44.0f : 20.0f)
#define MSC_NAVIGATION_BAR_HEIGHT 44.0f
#define MSC_STATUSBAR_NAVAGATIONBAR_HEIGHT (MSC_STATUSBAR_HEIGHT + MSC_NAVIGATION_BAR_HEIGHT)
#define MSC_TABBAR_HEIGHT (MSC_IS_iPhoneX ? 83.0f :49.0f)
#endif

#define MSC_IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)
typedef NS_ENUM(NSUInteger,MSCNavigationBarBackStyle) {
    MSCNavigationBarBackStyleNone,
    MSCNavigationBarBackStyleBlack,
    MSCNavigationBarBackStyleWhite
};
static inline void msc_swizzled_method(Class oldclass,
                                       NSString *oldSelector,
                                       Class newClass) {
//    NSString *newSelector = [NSString stringWithFormat:@"msc_ %@",oldSelector];
//    SEL originalSelector = NSSelectorFromString(oldSelector);
//    SEL swizzledSelector = NSSelectorFromString(newSelector);
//    Method originalMethod = class_getInstanceMethod(oldClass,NSSelectorFromString(oldSelector));
//    Method SwizzledMethod = class_getInstanceMethod(newClass,NSSelectorFromString(newSelector));
//    BOOL isAdd = class_AddMethod(oldClass,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
//    if (isAdd) {
//        class_replaceMethod(newClass,swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
//    }else {
//        method_exchangeImplementations(originalMethod,swizzledMethod);
//    }
}
#pragma mark - Position X & Y (not leading & Y)
#define CONSTRAINT_POSITIONING_X(VIEW, X) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeLeft multiplier: 1.0f constant: X]
#define CONSTRAINT_POSITIONING_LEADING(VIEW, X) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeLeading multiplier: 1.0f constant: X]
#define CONSTRAINT_POSITIONING_Y(VIEW, Y) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeTop multiplier: 1.0f constant: Y]
#define CONSTRAINTS_POSITION(VIEW, X, Y) @[CONSTRAINT_POSITIONING_X(VIEW, X), CONSTRAINT_POSITIONING_Y(VIEW, Y)]

#pragma mark - Size
// Width and Height
#define CONSTRAINT_SETTING_WIDTH(VIEW, WIDTH) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0f constant: WIDTH]
#define CONSTRAINT_SETTING_HEIGHT(VIEW, HEIGHT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0f constant: HEIGHT]

// Min Width and Height
#define CONSTRAINT_SETTING_MIN_WIDTH(VIEW, WIDTH) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationGreaterThanOrEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0f constant: WIDTH]
#define CONSTRAINT_SETTING_MIN_HEIGHT(VIEW, HEIGHT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationGreaterThanOrEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0f constant: HEIGHT]

// Max Width and Height
#define CONSTRAINT_SETTING_MAX_WIDTH(VIEW, WIDTH) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationLessThanOrEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0f constant: WIDTH]
#define CONSTRAINT_SETTING_MAX_HEIGHT(VIEW, HEIGHT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationLessThanOrEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0f constant: HEIGHT]

// Size
#define CONSTRAINTS_SETTING_SIZE(VIEW, WIDTH, HEIGHT) @[CONSTRAINT_SETTING_WIDTH(VIEW, WIDTH), CONSTRAINT_SETTING_HEIGHT(VIEW, HEIGHT)]
#define CONSTRAINTS_SETTING_MIN_SIZE(VIEW, WIDTH, HEIGHT) @[CONSTRAINT_SETTING_MIN_WIDTH(VIEW, WIDTH), CONSTRAINT_SETTING_MIN_HEIGHT(VIEW, HEIGHT)]
#define CONSTRAINTS_SETTING_MAX_SIZE(VIEW, WIDTH, HEIGHT) @[CONSTRAINT_SETTING_MAX_WIDTH(VIEW, WIDTH), CONSTRAINT_SETTING_MAX_HEIGHT(VIEW, HEIGHT)]

#pragma mark - Stretching
#define CONSTRAINT_STRETCHING_H(VIEW, INDENT) ^NSArray *(){VIEW_CLASS *_stretchview = VIEW; NSString *format = [NSString stringWithFormat:@"H:|-%d-[_stretchview]-%d-|", INDENT, INDENT]; NSArray *_tmparray = CONSTRAINTS(format, _stretchview); return _tmparray;}()
#define CONSTRAINT_STRETCHING_V(VIEW, INDENT) ^NSArray *(){VIEW_CLASS *_stretchview = VIEW; NSString *format = [NSString stringWithFormat:@"V:|-%d-[_stretchview]-%d-|", INDENT, INDENT]; NSArray *_tmparray = CONSTRAINTS(format, _stretchview); return _tmparray;}()
#define STRETCH_CONSTRAINTS(VIEW, INDENT) \
[CONSTRAINT_STRETCHING_H(VIEW, INDENT) arrayByAddingObjectsFromArray:CONSTRAINT_STRETCHING_V(VIEW, INDENT)]

#define CONSTRAINT_STRETCHING_PARTIAL_H(VIEW, PERCENT) [NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[VIEW superview] attribute:NSLayoutAttributeWidth multiplier:(PERCENT) constant:0]
#define CONSTRAINT_STRETCHING_PARTIAL_V(VIEW, PERCENT) [NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[VIEW superview] attribute:NSLayoutAttributeHeight multiplier:(PERCENT) constant:0]


#pragma mark - Matching
#define CONSTRAINT_MATCHING_WIDTH(VIEW, TOVIEW) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem:TOVIEW attribute: NSLayoutAttributeWidth multiplier: 1.0f constant:0]
#define CONSTRAINT_MATCHING_HEIGHT(VIEW, TOVIEW) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem:TOVIEW attribute: NSLayoutAttributeHeight multiplier: 1.0f constant:0]
#define CONSTRAINTS_MATCHING_SIZE(VIEW, TOVIEW) \
@[CONSTRAINT_MATCHING_WIDTH(VIEW, TOVIEW), CONSTRAINT_MATCHING_HEIGHT(VIEW, TOVIEW)]

#pragma mark - Centering
#define CONSTRAINT_CENTERING_H(VIEW) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeCenterX multiplier: 1.0f constant: 0.0f]
#define CONSTRAINT_CENTERING_V(VIEW) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeCenterY multiplier: 1.0f constant: 0.0f]
#define CONSTRAINTS_CENTERING(VIEW) \
@[CONSTRAINT_CENTERING_H(VIEW), CONSTRAINT_CENTERING_V(VIEW)]

#pragma mark - Alignment
// Left and Top, Leading
#define CONSTRAINT_ALIGNING_LEFT(VIEW, INDENT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeLeft multiplier: 1.0f constant: INDENT]
#define CONSTRAINT_ALIGNING_TOP(VIEW, INDENT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeTop multiplier: 1.0f constant: INDENT]
#define CONSTRAINT_ALIGNING_LEADING(VIEW, INDENT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeLeading multiplier: 1.0f constant: INDENT]

// Right, Bottom, Trailing -- indentation is adjusted backwards
#define CONSTRAINT_ALIGNING_RIGHT(VIEW, INDENT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeRight relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeRight multiplier: 1.0f constant: (-INDENT)]
#define CONSTRAINT_ALIGNING_BOTTOM(VIEW, INDENT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeBottom multiplier: 1.0f constant: (-INDENT)]
#define CONSTRAINT_ALIGNING_TRAILING(VIEW, INDENT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeTrailing multiplier: 1.0f constant: (-INDENT)]

#pragma mark - Aligning Pairs
// Left and Top, Leading
#define CONSTRAINT_ALIGNING_PAIR_LEFT(VIEW1, VIEW2, INDENT) [NSLayoutConstraint constraintWithItem: VIEW2 attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual toItem:VIEW1 attribute: NSLayoutAttributeLeft multiplier: 1.0f constant: INDENT]
#define CONSTRAINT_ALIGNING_PAIR_TOP(VIEW1, VIEW2, INDENT) [NSLayoutConstraint constraintWithItem: VIEW2 attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem:VIEW1 attribute: NSLayoutAttributeTop multiplier: 1.0f constant: INDENT]
#define CONSTRAINT_ALIGNING_PAIR_LEADING(VIEW1, VIEW2, OFFSET) [NSLayoutConstraint constraintWithItem: VIEW1 attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem:VIEW2 attribute: NSLayoutAttributeLeading multiplier: 1.0f constant: OFFSET]

// Right and Bottom, Trailing -- indentation is adjusted backwards
#define CONSTRAINT_ALIGNING_PAIR_RIGHT(VIEW1, VIEW2, INDENT) [NSLayoutConstraint constraintWithItem: VIEW2 attribute: NSLayoutAttributeRight relatedBy: NSLayoutRelationEqual toItem:VIEW1 attribute: NSLayoutAttributeRight multiplier: 1.0f constant: (-INDENT)]
#define CONSTRAINT_ALIGNING_PAIR_BOTTOM(VIEW1, VIEW2, INDENT) [NSLayoutConstraint constraintWithItem: VIEW2 attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem:VIEW1 attribute: NSLayoutAttributeBottom multiplier: 1.0f constant: (-INDENT)]
#define CONSTRAINT_ALIGNING_PAIR_TRAILING(VIEW1, VIEW2, OFFSET) [NSLayoutConstraint constraintWithItem: VIEW1 attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem:VIEW2 attribute: NSLayoutAttributeTrailing multiplier: 1.0f constant: (-OFFSET)]

// Centering -- No adjustments
#define CONSTRAINT_ALIGNING_PAIR_CENTERX(VIEW1, VIEW2, OFFSET) [NSLayoutConstraint constraintWithItem: VIEW2 attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem:VIEW1 attribute: NSLayoutAttributeCenterX multiplier: 1.0f constant: OFFSET]
#define CONSTRAINT_ALIGNING_PAIR_CENTERY(VIEW1, VIEW2, OFFSET) [NSLayoutConstraint constraintWithItem: VIEW2 attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem:VIEW1 attribute: NSLayoutAttributeCenterY multiplier: 1.0f constant: OFFSET]
#define CONSTRAINTS_ALIGNING_PAIR_CENTER(VIEW1, VIEW2, OFFSET) \
    @[CONSTRAINT_ALIGNING_PAIR_CENTERX(VIEW1, VIEW2, OFFSET), \
    CONSTRAINT_ALIGNING_PAIR_CENTERY(VIEW1, VIEW2, OFFSET)]

#pragma mark - Stacking
// Rows and Columns
#define CONSTRAINT_STACKING_H(VIEW1, VIEW2, BUFFERPOINTS) [NSLayoutConstraint constraintWithItem: VIEW2 attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem:VIEW1 attribute:NSLayoutAttributeTrailing multiplier: 1.0f constant:(BUFFERPOINTS)]
#define CONSTRAINT_STACKING_V(VIEW1, VIEW2, BUFFERPOINTS) [NSLayoutConstraint constraintWithItem: VIEW2 attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem:VIEW1 attribute:NSLayoutAttributeBottom multiplier: 1.0f constant:(BUFFERPOINTS)]

#pragma mark - Aspect
#define CONSTRAINT_SETTING_ASPECT(VIEW, ASPECT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem:VIEW attribute: NSLayoutAttributeHeight multiplier:(ASPECT) constant: 0.0f]
#define CONSTRAINT_SETTING_MIN_ASPECT(VIEW, ASPECT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationGreaterThanOrEqual toItem:VIEW attribute: NSLayoutAttributeHeight multiplier:(ASPECT) constant: 0.0f]
#define CONSTRAINT_SETTING_MAX_ASPECT(VIEW, ASPECT) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationLessThanOrEqual toItem:VIEW attribute: NSLayoutAttributeHeight multiplier:(ASPECT) constant: 0.0f]

/*
 *
 *
 PRACTICAL CONSTRAINTS
 Will grow this as needed. I've vastly trimmed it back for simplicity.
 These are commonly used items that don't often need priority tweaking,
 so priority is mostly hard-coded to a common value (DEFAULT_LAYOUT_PRIORITY)
 *
 *
 */

// Centering
#pragma mark - Centering
#define CENTER_H(VIEW) INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Centered View", CONSTRAINT_CENTERING_H(VIEW))
#define CENTER_V(VIEW) INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Centered View", CONSTRAINT_CENTERING_V(VIEW))
#define CENTER(VIEW)   {CENTER_H(VIEW); CENTER_V(VIEW);}

// Courtesy equivs
#define ALIGN_CENTER_H(VIEW)    CENTER_H(VIEW)
#define ALIGN_CENTER_V(VIEW)    CENTER_V(VIEW)

// Stretching
#pragma mark - Stretching
#define STRETCH_H(VIEW, INSET) INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Stretched View", CONSTRAINT_STRETCHING_H(VIEW, INSET))
#define STRETCH_V(VIEW, INSET) INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Stretched View", CONSTRAINT_STRETCHING_V(VIEW, INSET))
#define STRETCH(VIEW, INSET)   {STRETCH_H(VIEW, INSET); STRETCH_V(VIEW, INSET);}

// Exact Sizing
#pragma mark - Sizing Exact
#define CONSTRAIN_WIDTH(VIEW, WIDTH)        INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Constrain View Size", CONSTRAINT_SETTING_WIDTH(VIEW, WIDTH))
#define CONSTRAIN_HEIGHT(VIEW, HEIGHT)      INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Constrain View Size", CONSTRAINT_SETTING_HEIGHT(VIEW, HEIGHT))
#define CONSTRAIN_SIZE(VIEW, WIDTH, HEIGHT) {CONSTRAIN_WIDTH(VIEW, WIDTH); CONSTRAIN_HEIGHT(VIEW, HEIGHT);}

// Min and Max Sizing -- These almost always need priority tweaking so
// these macros include non-default priority
#pragma mark - Sizing Min and Max

#define CONSTRAIN_MIN_WIDTH(VIEW, WIDTH, PRIORITY) \
    INSTALL_CONSTRAINTS(PRIORITY, @"Constrain View Size", CONSTRAINT_SETTING_MIN_WIDTH(VIEW, WIDTH))
#define CONSTRAIN_MIN_HEIGHT(VIEW, HEIGHT, PRIORITY) \
    INSTALL_CONSTRAINTS(PRIORITY, @"Constrain View Size", CONSTRAINT_SETTING_MIN_HEIGHT(VIEW, HEIGHT))
#define CONSTRAIN__MIN_SIZE(VIEW, WIDTH, HEIGHT, PRIORITY) \
    {CONSTRAIN_MIN_WIDTH(VIEW, WIDTH, PRIORITY); \
    CONSTRAIN_MIN_HEIGHT(VIEW, HEIGHT, PRIORITY);}

#define CONSTRAIN_MAX_WIDTH(VIEW, WIDTH, PRIORITY) \
    INSTALL_CONSTRAINTS(PRIORITY, @"Constrain View Size", CONSTRAINT_SETTING_MAX_WIDTH(VIEW, WIDTH))
#define CONSTRAIN_MAX_HEIGHT(VIEW, HEIGHT, PRIORITY) \
    INSTALL_CONSTRAINTS(PRIORITY, @"Constrain View Size", CONSTRAINT_SETTING_MAX_HEIGHT(VIEW, HEIGHT))
#define CONSTRAIN__MAX_SIZE(VIEW, WIDTH, HEIGHT, PRIORITY) \
    {CONSTRAIN_MAX_WIDTH(VIEW, WIDTH, PRIORITY); \
    CONSTRAIN_MAX_HEIGHT(VIEW, HEIGHT, PRIORITY);}

// Matching
#pragma mark - Matching
#define MATCH_WIDTH(FROMVIEW, TOVIEW)  INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Match View Size", CONSTRAINT_MATCHING_WIDTH(FROMVIEW, TOVIEW))
#define MATCH_HEIGHT(FROMVIEW, TOVIEW) INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Match View Size", CONSTRAINT_MATCHING_HEIGHT(FROMVIEW, TOVIEW))
#define MATCH_SIZE(FROMVIEW, TOVIEW)   INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Match View Size", CONSTRAINTS_MATCHING_SIZE(FROMVIEW, TOVIEW))

#define MATCH_CENTERS(FROMVIEW, TOVIEW) INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Match Center", CONSTRAINTS_ALIGNING_PAIR_CENTER(FROMVIEW, TOVIEW))
#define MATCH_CENTERH(FROMVIEW, TOVIEW) INSTALL_CONSTRAINT(DEFAULT_LAYOUT_PRIORITY, @"Match Center", CONSTRAINT_ALIGNING_PAIR_CENTERX(FROMVIEW, TOVIEW, 0))
#define MATCH_CENTERV(FROMVIEW, TOVIEW) INSTALL_CONSTRAINT(DEFAULT_LAYOUT_PRIORITY, @"Match Center", CONSTRAINT_ALIGNING_PAIR_CENTERY(FROMVIEW, TOVIEW, 0))

// Aligning
#pragma mark - Aligning
#define ALIGN_LEFT(VIEW, INDENT)      INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align View", CONSTRAINT_ALIGNING_LEFT(VIEW, INDENT))
#define ALIGN_RIGHT(VIEW, INDENT)     INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align View", CONSTRAINT_ALIGNING_RIGHT(VIEW, INDENT))
#define ALIGN_TOP(VIEW, INDENT)       INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align View", CONSTRAINT_ALIGNING_TOP(VIEW, INDENT))
#define ALIGN_BOTTOM(VIEW, INDENT)    INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align View", CONSTRAINT_ALIGNING_BOTTOM(VIEW, INDENT))
#define ALIGN_LEADING(VIEW, INDENT)   INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align View", CONSTRAINT_ALIGNING_LEADING(VIEW, INDENT))
#define ALIGN_TRAILING(VIEW, INDENT)  INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align View", CONSTRAINT_ALIGNING_TRAILING(VIEW, INDENT))

// Alignment to the 9 cardinal points
#pragma mark - Cardinal Alignment
#define ALIGN_BOTTOMLEFT(VIEW, INDENT)    {ALIGN_BOTTOM(VIEW, INDENT); ALIGN_LEFT(VIEW, INDENT);}
#define ALIGN_BOTTOMRIGHT(VIEW, INDENT)   {ALIGN_BOTTOM(VIEW, INDENT); ALIGN_RIGHT(VIEW, INDENT);}
#define ALIGN_TOPLEFT(VIEW, INDENT)       {ALIGN_TOP(VIEW, INDENT); ALIGN_LEFT(VIEW, INDENT);}
#define ALIGN_TOPRIGHT(VIEW, INDENT)      {ALIGN_TOP(VIEW, INDENT); ALIGN_RIGHT(VIEW, INDENT);}
#define ALIGN_CENTER(VIEW)                {CENTER_H(VIEW); CENTER_V(VIEW);}
#define ALIGN_CENTERBOTTOM(VIEW, INDENT)  {ALIGN_BOTTOM(VIEW, INDENT); CENTER_H(VIEW);}
#define ALIGN_CENTERTOP(VIEW, INDENT)     {ALIGN_TOP(VIEW, INDENT); CENTER_H(VIEW);}
#define ALIGN_CENTERRIGHT(VIEW, INDENT)   {ALIGN_RIGHT(VIEW, INDENT); CENTER_V(VIEW);}
#define ALIGN_CENTERLEFT(VIEW, INDENT)    {ALIGN_LEFT(VIEW, INDENT); CENTER_V(VIEW);}

// Pair alignment
#pragma mark - Pair Alignment
#define ALIGN_PAIR_LEFT(VIEW1, VIEW2)       INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align Pair", CONSTRAINT_ALIGNING_PAIR_LEFT(VIEW1, VIEW2, 0))
#define ALIGN_PAIR_LEADING(VIEW1, VIEW2)    INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align Pair", CONSTRAINT_ALIGNING_PAIR_LEADING(VIEW1, VIEW2, 0))
#define ALIGN_PAIR_RIGHT(VIEW1, VIEW2)      INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align Pair", CONSTRAINT_ALIGNING_PAIR_RIGHT(VIEW1, VIEW2, 0))
#define ALIGN_PAIR_CENTERX(VIEW1, VIEW2)    INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align Pair", CONSTRAINT_ALIGNING_PAIR_CENTERX(VIEW1, VIEW2, 0))
#define ALIGN_PAIR_TRAILING(VIEW1, VIEW2)   INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align Pair", CONSTRAINT_ALIGNING_PAIR_TRAILING(VIEW1, VIEW2, 0))
#define ALIGN_PAIR_TOP(VIEW1, VIEW2)        INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align Pair", CONSTRAINT_ALIGNING_PAIR_TOP(VIEW1, VIEW2, 0))
#define ALIGN_PAIR_CENTERY(VIEW1, VIEW2)    INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align Pair", CONSTRAINT_ALIGNING_PAIR_CENTERY(VIEW1, VIEW2, 0))
#define ALIGN_PAIR_BOTTOM(VIEW1, VIEW2)     INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Align Pair", CONSTRAINT_ALIGNING_PAIR_BOTTOM(VIEW1, VIEW2, 0))


// Place In Row or Column
#pragma mark - Rows and Columns
#define LAYOUT_H(VIEW1, OFFSET, VIEW2) INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Create Row", CONSTRAINT_STACKING_H(VIEW1, VIEW2, OFFSET), CONSTRAINT_ALIGNING_PAIR_CENTERY(VIEW1, VIEW2, 0))
#define LAYOUT_V(VIEW1, OFFSET, VIEW2) INSTALL_CONSTRAINTS(DEFAULT_LAYOUT_PRIORITY, @"Create Column", CONSTRAINT_STACKING_V(VIEW1, VIEW2, OFFSET), CONSTRAINT_ALIGNING_PAIR_CENTERX(VIEW1, VIEW2, 0))

#pragma mark - Content Size Layout



#pragma mark iOS

// Content Hugging
#define HUG_H(VIEW, PRIORITY) [VIEW setContentHuggingPriority:(PRIORITY) forAxis:UILayoutConstraintAxisHorizontal]
#define HUG_V(VIEW, PRIORITY) [VIEW setContentHuggingPriority:(PRIORITY) forAxis:UILayoutConstraintAxisVertical]
#define HUG(VIEW, PRIORITY) {HUG_H(VIEW, PRIORITY); HUG_V(VIEW, PRIORITY);}

// Compression Resistance
#define RESIST_H(VIEW, PRIORITY) [VIEW setContentCompressionResistancePriority:(PRIORITY) forAxis:UILayoutConstraintAxisHorizontal]
#define RESIST_V(VIEW, PRIORITY) [VIEW setContentCompressionResistancePriority:(PRIORITY) forAxis:UILayoutConstraintAxisVertical]
#define RESIST(VIEW, PRIORITY) {RESIST_H(VIEW, PRIORITY); RESIST_V(VIEW, PRIORITY);}

static inline CGFloat DegreesToRadians(CGFloat degrees)
{
    return M_PI * (degrees / 180.0);
}

#define checkNull(__X__)        (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#pragma mark OS X

// Content Hugging
#define HUG_H(VIEW, PRIORITY) [VIEW setContentHuggingPriority:(PRIORITY) forOrientation:NSLayoutConstraintOrientationHorizontal]
#define HUG_V(VIEW, PRIORITY) [VIEW setContentHuggingPriority:(PRIORITY) forOrientation:NSLayoutConstraintOrientationVertical]
#define HUG(VIEW, PRIORITY) {HUG_H(VIEW, PRIORITY); HUG_V(VIEW, PRIORITY);}

// Compression Resistance
#define RESIST_H(VIEW, PRIORITY) [VIEW setContentCompressionResistancePriority:(PRIORITY) forOrientation:NSLayoutConstraintOrientationHorizontal]
#define RESIST_V(VIEW, PRIORITY) [VIEW setContentCompressionResistancePriority:(PRIORITY) forOrientation:NSLayoutConstraintOrientationVertical]
#define RESIST(VIEW, PRIORITY) {RESIST_H(VIEW, PRIORITY); RESIST_V(VIEW, PRIORITY);}


#define weakify(...) \\
    autoreleasepool {} \\
    metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)

#define strongify(...) \\
    try {} @finally {} \\
    _Pragma("clang diagnostic push") \\
    _Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
    metamacro_foreach(rac_strongify_,, __VA_ARGS__) \\
    _Pragma("clang diagnostic pop")
#define MSAAssertTrue(condition, msg) do {\ if (!condition) {\
NSLog(@"failed: " @ #condition @" " msg);\ }\
} while(0)


#pragma mark Collections

#define IDARRAY(...) (id []){ __VA_ARGS__ }
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))

#define ARRAY(...) [NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)]

#define DICT(...) DictionaryWithIDArray(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

//The helper function unpacks the object array and then calls through to NSDictionary to create the dictionary:
static inline NSDictionary *DictionaryWithIDArray(id *array, NSUInteger count) {
    id keys[count];
    id objs[count];
    
    for(NSUInteger i = 0; i < count; i++) {
        keys[i] = array[i * 2];
        objs[i] = array[i * 2 + 1];
    }
    
    return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
}
#define POINTERIZE(x) ((__typeof__(x) []){ x })
#define NSVALUE(x) [NSValue valueWithBytes: POINTERIZE(x) objCType: @encode(__typeof__(x))]

#pragma mark -
#pragma mark Blocks

#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil

#pragma mark -
#pragma mark Logging

#define LOG(fmt, ...) NSLog(@"%s: " fmt, __PRETTY_FUNCTION__, ## __VA_ARGS__)

#ifdef DEBUG
    #define INFO(fmt, ...) LOG(fmt, ## __VA_ARGS__)
#else
    // do nothing
    #define INFO(fmt, ...) 
#endif

#define ERROR(fmt, ...) LOG(fmt, ## __VA_ARGS__)
#define TRACE(fmt, ...) LOG(fmt, ## __VA_ARGS__)

#define METHOD_NOT_IMPLEMENTED() NSAssert(NO, @"You must override %@ in a subclass", NSStringFromSelector(_cmd))

#pragma mark NSNumber

#define NUM_INT(int) [NSNumber numberWithInt:int]
#define NUM_FLOAT(float) [NSNumber numberWithFloat:float]
#define NUM_BOOL(bool) [NSNumber numberWithBool:bool]

#pragma mark -
#pragma mark Frame Geometry

#define CENTER_VERTICALLY(parent,child) floor((parent.frame.size.height - child.frame.size.height) / 2)
#define CENTER_HORIZONTALLY(parent,child) floor((parent.frame.size.width - child.frame.size.width) / 2)

// example: [[UIView alloc] initWithFrame:(CGRect){CENTER_IN_PARENT(parentView,500,500),CGSizeMake(500,500)}];
#define CENTER_IN_PARENT(parent,childWidth,childHeight) CGPointMake(floor((parent.frame.size.width - childWidth) / 2),floor((parent.frame.size.height - childHeight) / 2))
#define CENTER_IN_PARENT_X(parent,childWidth) floor((parent.frame.size.width - childWidth) / 2)
#define CENTER_IN_PARENT_Y(parent,childHeight) floor((parent.frame.size.height - childHeight) / 2)

#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height) 
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width) 

#define MSAssertTrue(condition) do {\ if (condition) {\
NSLog(@"passed: " @ #condition);\ } else {\
NSLog(@"failed: " @ #condition);\ }\
} while(0)





//#endif /* MSCCommon_h */
