//
//  NSDate+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSDate+Common.h"
#import "NSDate+BoolJudge.h"

@implementation NSDate (Common)

+ (NSCalendar *)po_currentCalendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

+ (NSDate *)po_dateWithDaysFromNow:(NSInteger)days {
    return [[NSDate date] po_dateByAddingDays:days];
}

+ (NSDate *)po_dateWithDaysBeforeNow:(NSInteger)days {
    return [[NSDate date] po_dateBySubtractingDays:days];
}

+ (NSDate *)po_dateTomorrow {
    return [NSDate po_dateWithDaysFromNow:1];
}

+ (NSDate *)po_dateYesterday {
    return [NSDate po_dateWithDaysBeforeNow:1];
}

+ (NSDate *)po_dateWithHoursFromNow:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)po_dateWithHoursBeforeNow:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)po_dateWithMinutesFromNow:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)po_dateWithMinutesBeforeNow:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark Adjusting Dates

- (NSDate *)po_dateByAddingYears:(NSInteger)years {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:years];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)po_dateBySubtractingYears:(NSInteger)years {
    return [self po_dateByAddingYears:-years];
}

- (NSDate *)po_dateByAddingMonths:(NSInteger)months {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:months];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)po_dateBySubtractingMonths:(NSInteger)months {
    return [self po_dateByAddingMonths:-months];
}

- (NSDate *)po_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)po_dateBySubtractingDays:(NSInteger)days {
    return [self po_dateByAddingDays: (days * -1)];
}

- (NSDate *)po_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)po_dateBySubtractingHours:(NSInteger)hours {
    return [self po_dateByAddingHours:(hours * -1)];
}

- (NSDate *)po_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)po_dateBySubtractingMinutes:(NSInteger)minutes {
    return [self po_dateByAddingMinutes:(minutes * -1)];
}

- (NSDateComponents *)po_componentsWithOffsetFromDate:(NSDate *)date {
    NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date toDate:self options:0];
    return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger)po_minutesAfterDate:(NSDate *)date {
    NSTimeInterval time = [self timeIntervalSinceDate:date];
    return (NSInteger) (time / D_MINUTE);
}

- (NSInteger)po_minutesBeforeDate:(NSDate *)date {
    NSTimeInterval time = [date timeIntervalSinceDate:self];
    return (NSInteger) (time / D_MINUTE);
}

- (NSInteger)po_hoursAfterDate:(NSDate *)date {
    NSTimeInterval time = [self timeIntervalSinceDate:date];
    return (NSInteger) (time / D_HOUR);
}

- (NSInteger)po_hoursBeforeDate:(NSDate *)date {
    NSTimeInterval time = [date timeIntervalSinceDate:self];
    return (NSInteger) (time / D_HOUR);
}

- (NSInteger)po_daysAfterDate:(NSDate *)date {
    NSTimeInterval time = [self timeIntervalSinceDate:date];
    return (NSInteger) (time / D_DAY);
}

- (NSInteger)po_daysBeforeDate:(NSDate *)date {
    NSTimeInterval time = [date timeIntervalSinceDate:self];
    return (NSInteger) (time / D_DAY);
}

#pragma mark Decomposing Dates

- (NSInteger)po_nearestHour {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger)po_year {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}

- (NSInteger)po_month {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger)po_day {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger)po_hour {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger)po_minute {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger)po_seconds {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger)po_weekday {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

- (NSInteger)po_weekdayOrdinal {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekdayOrdinal;
}

#pragma mark -

- (NSDate *)po_dateAtStartOfDay {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)po_dateAtEndOfDay {
    NSDateComponents *components = [[NSDate po_currentCalendar] components:DATE_COMPONENTS fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [[NSDate po_currentCalendar] dateFromComponents:components];
}

- (NSDate *)timelessDate  {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    return [calendar dateFromComponents:comp];
}

- (NSDate *)monthlessDate  {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:self];
    
    return [calendar dateFromComponents:comp];
}

- (NSInteger)po_monthsBetweenDate:(NSDate *)toDate {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:[self monthlessDate] toDate:[toDate monthlessDate] options:0];
    
    return abs((int)[components month]);
}

- (NSInteger)po_daysBetweenDate:(NSDate *)anotherDate {
    NSTimeInterval time = [self timeIntervalSinceDate:anotherDate];
    return (NSInteger)fabs(time / 60 / 60 / 24);
}

+ (NSDate *)po_systemDateFromInternationalDate:(NSDate *)date {
    //设置源日期时区
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate *systemDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    return systemDate;
}

+ (NSString *)po_timeRemainWithSeconds:(NSInteger)second {
    
    // 如果大于1年 返回 N年
    if (second > D_YEAR) {
        return [NSString stringWithFormat:@"%ld年", second / D_YEAR];
    }
    
    // 如果大于1月 返回 N月
    if (second > D_Month) {
        return [NSString stringWithFormat:@"%ld月", second / D_Month];
    }
    
    // 如果大于1天 返回 N天
    if (second > D_DAY) {
        return [NSString stringWithFormat:@"%ld天", second / D_DAY];
    }
    
    // 如果大于1时 返回 N时
    if (second > D_HOUR) {
        return [NSString stringWithFormat:@"%ld时", second / D_HOUR];
    }
    
    // 如果大于1分 返回 N分
    if (second > D_MINUTE) {
        return [NSString stringWithFormat:@"%ld分", second / D_MINUTE];
    }
    
    return [NSString stringWithFormat:@"%ld秒", second];
}

+ (NSString *)po_timeApartWithTimestamp:(long long)timestamp {
    
    if (timestamp <= 0) {
        return @"";
    }
    
    // 获取时间戳
    long long netInterval = timestamp > 100000000 ? timestamp /1000 : timestamp;
    
    // 当前时间戳
    NSTimeInterval sinceInterval = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    
    // 得到时间戳距 秒
    int timeInterval = sinceInterval - netInterval;
    
    // 如果大于1年 返回 N年前
    if (timeInterval > D_YEAR) {
        return [NSString stringWithFormat:@"%d年前", timeInterval / D_YEAR];
    }
    
    // 如果大于1月 返回 N月前
    if (timeInterval > D_Month) {
        return [NSString stringWithFormat:@"%d月前", timeInterval / D_Month];
    }
    
    // 如果大于1天 返回 N天前
    if (timeInterval > D_DAY) {
        return [NSString stringWithFormat:@"%d天前", timeInterval / D_DAY];
    }
    
    // 如果大于1时 返回 N时前
    if (timeInterval > D_HOUR) {
        return [NSString stringWithFormat:@"%d小时前", timeInterval / D_HOUR];
    }
    
    // 如果大于1分 返回 N分前
    if (timeInterval > D_MINUTE) {
        return [NSString stringWithFormat:@"%d分钟前", timeInterval / D_MINUTE];
    }
    
    return [NSString stringWithFormat:@"%d秒前", timeInterval];
}

+ (NSInteger)po_numberOfDaysInCurrentMonth {
    return [NSDate po_numberOfDaysInDate:[NSDate date]];
}

+ (NSInteger)po_numberOfDaysInDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

+ (NSInteger)po_numberOfWeeksInCurrentMonth {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:currentDate];
    return range.length;
}

+ (NSInteger)po_numberOfWeeksInDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

+ (NSInteger)po_indexOfWeekForFirstDayInCurrentMonth {
    return [NSDate po_indexOfWeekForFirstDayInDate:[NSDate date]];
}

+ (NSInteger)po_indexOfWeekForFirstDayInDate:(NSDate *)date {
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger indexOfWeek = [dateComponents weekday];
    
    return indexOfWeek;
}

+ (NSInteger)po_indexOfMonthForTodayInCurrentMonth {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay fromDate:currentDate];
    return [dateComponents day];
}

+ (NSString *)po_timeStringWithTimeType:(CurrentTimeType)timeType {
    return [self po_timeStringByDate:[NSDate date] timeType:timeType];
}

+ (NSString *)po_timeStringByDate:(NSDate *)date
                         timeType:(CurrentTimeType)timeType {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self getTimeType:timeType]];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)po_timeStringByTimestamp:(NSString *)timestamp
                              timeType:(CurrentTimeType)timeType {
    
    if (!timestamp) {
        return @"";
    }
    
    NSTimeInterval time = timestamp.length > 11 ? [timestamp doubleValue]/1000 : [timestamp doubleValue];
    NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self getTimeType:timeType]];
    
    return [dateFormatter stringFromDate:secondDate];
}

+ (NSDate *)po_dateByTimestamp:(NSString *)timestamp {
    
    if (!timestamp) {
        return nil;
    }
    
    NSTimeInterval time = timestamp.length > 11 ? [timestamp doubleValue]/1000 : [timestamp doubleValue];
    NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    return secondDate;
}

+ (NSDate *)po_dateByString:(NSString *)dateString
                   timeType:(CurrentTimeType)timeType {
    
    if (!dateString.length) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self getTimeType:timeType]];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
//    return [NSDate po_systemDateFromInternationalDate:date];
}

+ (long)po_timestampByDate:(NSDate *)date {
    return [date timeIntervalSince1970] * 1000;
}

/**
 *  获得时间类型
 *
 *  @param timeType 所需时间类型
 *
 *  @return 返回时间格式
 */
+ (NSString *)getTimeType:(CurrentTimeType)timeType {
    
    NSString *type = nil;
    switch (timeType) {
        case CurrentTimeTypeY_M:
            type = @"yyyy-MM";
            break;
        case CurrentTimeTypeY_M_Point:
            type = @"yyyy.MM";
            break;
        case CurrentTimeTypeY_M_Sprit:
            type = @"yyyy/MM";
            break;
        case CurrentTimeTypeY_M_ByChinese:
            type = @"yyyy年MM月";
            break;
        case CurrentTimeTypeY_M_d:
            type = @"yyyy-MM-dd";
            break;
        case CurrentTimeTypeY_M_d_Point:
            type = @"yyyy.MM.dd";
            break;
        case CurrentTimeTypeY_M_d_Sprit:
            type = @"yyyy/MM/dd";
            break;
        case CurrentTimeTypeY_M_d_ByChinese:
            type = @"yyyy年MM月dd日";
            break;
        case CurrentTimeTypeH_m:
            type = @"HH:mm";
            break;
        case CurrentTimeTypeH_m_s:
            type = @"HH:mm:ss";
            break;
        case CurrentTimeTypeM_d:
            type = @"MM-dd";
            break;
        case CurrentTimeTypeM_d_Sprit:
            type = @"MM/dd";
            break;
        case CurrentTimeTypeM_d_H_m:
            type = @"MM-dd HH:mm";
            break;
        case CurrentTimeTypeM_d_H_m_Sprit:
            type = @"MM/dd HH:mm";
            break;
        case CurrentTimeTypeY_M_d_H_m:
            type = @"yyyy-MM-dd HH:mm";
            break;
        case CurrentTimeTypeY_M_d_H_m_Sprit:
            type = @"yyyy/MM/dd HH:mm";
            break;
        case CurrentTimeTypeY_M_d_H_m_s:
            type = @"yyyy-MM-dd HH:mm:ss";
            break;
        case CurrentTimeTypeY_M_d_H_m_s_Sprit:
            type = @"yyyy/MM/dd HH:mm:ss";
            break;
        case CurrentTimeTypeY_M_d_H_m_s_ss:
            type = @"yyyy-MM-dd HH:mm:ss.SSS";
            break;
        case CurrentTimeTypeE_H_m:
            type = @"EEEE HH:mm";
            break;
        case CurrentTimeTypeE:
            type = @"EEEE";
            break;
        case CurrentTimeTypeY:
            type = @"yyyy";
            break;
        case CurrentTimeTypeM:
            type = @"MM";
            break;
        case CurrentTimeTypeD:
            type = @"dd";
            break;
        default:
            break;
    }
    
    return type;
}

@end
