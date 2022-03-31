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

NS_ASSUME_NONNULL_END
