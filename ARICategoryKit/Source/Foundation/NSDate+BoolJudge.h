//
//  NSDate+BoolJudge.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 年 月 周 日 时 分  所对应秒数
#define D_MINUTE     60
#define D_HOUR       3600
#define D_DAY        86400
#define D_WEEK       604800
#define D_Month      2592000
#define D_YEAR       31536000

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@interface NSDate (BoolJudge)

/**
 与某时间是否是同年同月同日
 */
- (BOOL)po_isSameDay:(NSDate *)date;

/**
 是否今天
 */
- (BOOL)po_isToday;

/**
 是否明天
 */
- (BOOL)po_isTomorrow;

/**
 是否昨天
 */
- (BOOL)po_isYesterday;

/**
 是否同一周
 */
- (BOOL)po_isSameWeekAsDate:(NSDate *)date;

/**
 是否这周
 */
- (BOOL)po_isThisWeek;

/**
 是否下周
 */
- (BOOL)po_isNextWeek;

/**
 是否上周
 */
- (BOOL)po_isLastWeek;

/**
 是否同一个月
 */
- (BOOL)po_isSameMonthAsDate:(NSDate *)date;

/**
 是否这个月
 */
- (BOOL)po_isThisMonth;

/**
 是否下一个月
 */
- (BOOL)po_isNextMonth;

/**
 是否上一个月
 */
- (BOOL)po_isLastMonth;

/**
 是否同一年
 */
- (BOOL)po_isSameYearAsDate:(NSDate *)date;

/**
 是否这年
 */
- (BOOL)po_isThisYear;

/**
 是否明年
 */
- (BOOL)po_isNextYear;

/**
 是否去年
 */
- (BOOL)po_isLastYear;

/**
 当前时间是否早于某时间
 
 @param date 某时间
 */
- (BOOL)po_isEarlierThanDate:(NSDate *)date;

/**
 当前时间是否晚于某时间
 
 @param date 某时间
 */
- (BOOL)po_isLaterThanDate:(NSDate *)date;

/**
 当前时间是否在两时间之间
 
 @param startDate 最早时间
 @param endDate   最晚时间
 */
- (BOOL)po_isSectionInStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

/**
 判断某个时间区间是否跟某个时间区间有重合，有的话返回True
 
 @param currentFromDate   当前时间段-起始时间
 @param currentToDate   当前时间段-终止时间
 @param caseFromDate   比较时间段-起始时间
 @param caseToDate   比较时间段-终止时间
 */
+ (BOOL)po_compareCurrentFromDate:(NSDate *)currentFromDate currentToDate:(NSDate *)currentToDate sectionCaseFromDate:(NSDate *)caseFromDate caseToDate:(NSDate *)caseToDate;

/**
 是否周末
 */
- (BOOL)po_isWorkday;

/**
 是否工作日
 */
- (BOOL)po_isWeekend;

@end

NS_ASSUME_NONNULL_END
