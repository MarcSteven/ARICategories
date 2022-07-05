//
//  NSDate+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 时间类型
typedef enum {
    /**
     *  年_月
     */
    CurrentTimeTypeY_M,
    /**
     *  年.月
     */
    CurrentTimeTypeY_M_Point,
    /**
     *  年/月
     */
    CurrentTimeTypeY_M_Sprit,
    /**
     *  Y年M月
     */
    CurrentTimeTypeY_M_ByChinese,
    /**
     *  年_月_日
     */
    CurrentTimeTypeY_M_d,
    /**
     *  年.月.日
     */
    CurrentTimeTypeY_M_d_Point,
    /**
     *  年/月/日
     */
    CurrentTimeTypeY_M_d_Sprit,
    /**
     *  Y年M月D日
     */
    CurrentTimeTypeY_M_d_ByChinese,
    /**
     *  时:分
     */
    CurrentTimeTypeH_m,
    /**
     *  时:分:秒
     */
    CurrentTimeTypeH_m_s,
    /**
     *  月_日
     */
    CurrentTimeTypeM_d,
    /**
     *  月/日
     */
    CurrentTimeTypeM_d_Sprit,
    /**
     *  月_日 时:分
     */
    CurrentTimeTypeM_d_H_m,
    /**
     *  月/日 时:分
     */
    CurrentTimeTypeM_d_H_m_Sprit,
    /**
     *  年_月_日 时:分
     */
    CurrentTimeTypeY_M_d_H_m,
    /**
     *  年/月/日 时:分
     */
    CurrentTimeTypeY_M_d_H_m_Sprit,
    /**
     *  年_月_日 时:分:秒
     */
    CurrentTimeTypeY_M_d_H_m_s,
    /**
     *  年/月/日 时:分:秒
     */
    CurrentTimeTypeY_M_d_H_m_s_Sprit,
    /**
     *  年_月_日 时:分:秒:毫秒
     */
    CurrentTimeTypeY_M_d_H_m_s_ss,
    /**
     *  星期 时:分
     */
    CurrentTimeTypeE_H_m,
    /**
     *  星期
     */
    CurrentTimeTypeE,
    /**
     *  年
     */
    CurrentTimeTypeY,
    /**
     *  月
     */
    CurrentTimeTypeM,
    /**
     *  日
     */
    CurrentTimeTypeD,
    
}CurrentTimeType;

@interface NSDate (Common)

#pragma mark - 从当前日期相对日期

/// 明天
+ (NSDate *)po_dateTomorrow;
/// 昨天
+ (NSDate *)po_dateYesterday;
/// 当前时间 + xx天
+ (NSDate *)po_dateWithDaysFromNow:(NSInteger)days;
/// 当前时间 - xx天
+ (NSDate *)po_dateWithDaysBeforeNow:(NSInteger)days;
/// 当前时间 + xx小时
+ (NSDate *)po_dateWithHoursFromNow:(NSInteger)hours;
/// 当前时间 - xx小时
+ (NSDate *)po_dateWithHoursBeforeNow:(NSInteger)hours;
/// 当前时间 + xx分钟
+ (NSDate *)po_dateWithMinutesFromNow:(NSInteger)minutes;
/// 当前时间 - xx分钟
+ (NSDate *)po_dateWithMinutesBeforeNow:(NSInteger)minutes;

#pragma mark - 对某时间进行加减处理

/// 对某时间 + xx年
- (NSDate *)po_dateByAddingYears:(NSInteger)years;
/// 对某时间 - xx年
- (NSDate *)po_dateBySubtractingYears:(NSInteger)years;
/// 对某时间 + xx月
- (NSDate *)po_dateByAddingMonths:(NSInteger)months;
/// 对某时间 - xx月
- (NSDate *)po_dateBySubtractingMonths:(NSInteger)months;
/// 对某时间 + xx天
- (NSDate *)po_dateByAddingDays:(NSInteger)days;
/// 对某时间 - xx天
- (NSDate *)po_dateBySubtractingDays:(NSInteger)days;
/// 对某时间 + xx小时
- (NSDate *)po_dateByAddingHours:(NSInteger)hours;
/// 对某时间 - xx小时
- (NSDate *)po_dateBySubtractingHours:(NSInteger)hours;
/// 对某时间 + xx分钟
- (NSDate *)po_dateByAddingMinutes:(NSInteger)minutes;
/// 对某时间 - xx分钟
- (NSDate *)po_dateBySubtractingMinutes:(NSInteger)minutes;

#pragma mark - 检索时间间隔

/// 当前时间晚于某时间 xx分钟
- (NSInteger)po_minutesAfterDate:(NSDate *)date;
/// 当前时间早于某时间 xx分钟
- (NSInteger)po_minutesBeforeDate:(NSDate *)date;
/// 当前时间晚于某时间 xx小时
- (NSInteger)po_hoursAfterDate:(NSDate *)date;
/// 当前时间早于某时间 xx小时
- (NSInteger)po_hoursBeforeDate:(NSDate *)date;
/// 当前时间晚于某时间 xx天
- (NSInteger)po_daysAfterDate:(NSDate *)date;
/// 当前时间早于某时间 xx天
- (NSInteger)po_daysBeforeDate:(NSDate *)date;

#pragma mark - 分解的当前时间日期

/// 当前 年
@property (readonly) NSInteger po_year;
/// 当前 月
@property (readonly) NSInteger po_month;
/// 当前 天
@property (readonly) NSInteger po_day;
/// 当前 时
@property (readonly) NSInteger po_hour;
/// 当前 分
@property (readonly) NSInteger po_minute;
/// 当前 秒
@property (readonly) NSInteger po_seconds;
/// 当前 周几  （日-1 一-2 二-3 三-4 四-5 五-6 六-7）
@property (readonly) NSInteger po_weekday;
/// 当前 第x个周几
@property (readonly) NSInteger po_weekdayOrdinal; // e.g. 2nd Tuesday of the month == 2
/// 当前时间的 上个小时
@property (readonly) NSInteger po_nearestHour;

/**
 获取时间 尾缀是 00:00:00
 */
- (NSDate *)po_dateAtStartOfDay;

/**
 获取时间 尾缀是 23:59:59
 */
- (NSDate *)po_dateAtEndOfDay;

/**
 *  获取当天到某时间段直接的月数
 */
- (NSInteger)po_monthsBetweenDate:(NSDate *)toDate;

/**
 *  获取当天到某时间段直接的天数
 */
- (NSInteger)po_daysBetweenDate:(NSDate *)toDate;

/**
 国际时间转换为当前系统时间
 
 @param date 国际时间
 */
+ (NSDate *)po_systemDateFromInternationalDate:(NSDate *)date;

/**
 根据秒数获取剩余时间描述 ps：几分钟
 
 @param second 秒数
 */
+ (NSString *)po_timeRemainWithSeconds:(NSInteger)second;

/**
 根据时间戳获取相距此时的时间描述 ps：几分钟前
 
 @param timestamp 时间戳
 */
+ (NSString *)po_timeApartWithTimestamp:(long long)timestamp;

/**
 *  获取当前月总共有多少天
 */
+ (NSInteger)po_numberOfDaysInCurrentMonth;

/**
 *  获取某月总共有多少天
 */
+ (NSInteger)po_numberOfDaysInDate:(NSDate *)date;

/**
 *  获取当前月中共有多少周
 */
+ (NSInteger)po_numberOfWeeksInCurrentMonth;

/**
 *  获取某月中共有多少周
 */
+ (NSInteger)po_numberOfWeeksInDate:(NSDate *)date;

/**
 *  获取当前月中第一天在一周内的索引
 */
+ (NSInteger)po_indexOfWeekForFirstDayInCurrentMonth;

/**
 *  获取某月第一天在一周内的索引
 */
+ (NSInteger)po_indexOfWeekForFirstDayInDate:(NSDate *)date;

/**
 *  获取当天在当月中的索引(第几天)
 */
+ (NSInteger)po_indexOfMonthForTodayInCurrentMonth;

/**
 *  获取当前时间
 *
 *  @param timeType 时间格式
 */
+ (NSString *)po_timeStringWithTimeType:(CurrentTimeType)timeType;

/**
 *  根据时间date获取时间
 *
 *  @param date      时间
 *  @param timeType  时间格式
 */
+ (NSString *)po_timeStringByDate:(NSDate *)date
                         timeType:(CurrentTimeType)timeType;

/**
 *  根据时间戳获取时间
 *
 *  @param timestamp 时间戳
 *  @param timeType  时间格式
 */
+ (NSString *)po_timeStringByTimestamp:(NSString *)timestamp
                              timeType:(CurrentTimeType)timeType;

/**
 *  根据时间戳获取时间
 *
 *  @param timestamp 时间戳
 */
+ (NSDate *)po_dateByTimestamp:(NSString *)timestamp;

/**
 *  根据时间文本获取时间
 *
 *  @param dateString 时间文本
 *  @param timeType  时间格式
 */
+ (NSDate *)po_dateByString:(NSString *)dateString timeType:(CurrentTimeType)timeType;

/**
 *  根据时间date获取时间戳
 *
 *  @param date 时间
 */
+ (long)po_timestampByDate:(NSDate *)date;

@end

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


@implementation NSData (Conversion)
#pragma mark - string conversion

- (NSString *)hexadecimalString {
    const unsigned char *dataBuffer  = (const unsigned char *)[self bytes];
    if (!dataBuffer) {
        return [NSString string];
    }
    NSInteger dataLength = [self length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0 ; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx",(unsigned long)dataBuffer[i]]];
        return [NSString stringWithString:hexString];
    
}
@end


NS_ASSUME_NONNULL_END
