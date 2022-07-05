//
//  NSDate+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSDate+Common.h"


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
@implementation NSDate (BoolJudge)

- (BOOL)po_isSameDay:(NSDate *)date {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)po_isToday {
    return [self po_isSameDay:[NSDate date]];
}

- (BOOL)po_isTomorrow {
    return [self po_isSameDay:[NSDate po_dateTomorrow]];
}

- (BOOL)po_isYesterday {
    return [self po_isSameDay:[NSDate po_dateYesterday]];
}

- (BOOL)po_isSameWeekAsDate:(NSDate *)date {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    return (fabs([self timeIntervalSinceDate:date]) < D_WEEK);
}

- (BOOL)po_isThisWeek {
    return [self po_isSameWeekAsDate:[NSDate date]];
}

- (BOOL)po_isNextWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self po_isSameWeekAsDate:newDate];
}

- (BOOL)po_isLastWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self po_isSameWeekAsDate:newDate];
}

- (BOOL)po_isSameMonthAsDate:(NSDate *)date {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL)po_isThisMonth {
    return [self po_isSameMonthAsDate:[NSDate date]];
}

- (BOOL)po_isLastMonth {
    return [self po_isSameMonthAsDate:[[NSDate date] po_dateBySubtractingMonths:1]];
}

- (BOOL)po_isNextMonth {
    return [self po_isSameMonthAsDate:[[NSDate date] po_dateByAddingMonths:1]];
}

- (BOOL)po_isSameYearAsDate:(NSDate *)date {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:date];
    return (components1.year == components2.year);
}

- (BOOL)po_isThisYear {
    return [self po_isSameYearAsDate:[NSDate date]];
}

- (BOOL)po_isNextYear {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year + 1));
}

- (BOOL)po_isLastYear {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}

- (BOOL)po_isEarlierThanDate:(NSDate *)date {
    return ([self compare:date] == NSOrderedAscending);
}

- (BOOL)po_isLaterThanDate:(NSDate *)date {
    return ([self compare:date] == NSOrderedDescending);
}

- (BOOL)po_isSectionInStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    
    if (![self po_isEarlierThanDate:startDate] && ![self po_isLaterThanDate:endDate]) {
        return YES;
    }
    
    return NO;
}

/// 判断某个时间区间是否跟某个时间区间有重合，有的话返回True
+ (BOOL)po_compareCurrentFromDate:(NSDate *)currentFromDate currentToDate:(NSDate *)currentToDate sectionCaseFromDate:(NSDate *)caseFromDate caseToDate:(NSDate *)caseToDate {
    
    if (caseFromDate && caseToDate) {
        
        // 当先判断头尾是否一致
        NSString *currentLast = [NSDate po_timeStringByDate:currentToDate timeType:CurrentTimeTypeY_M_d_H_m];
        NSString *caseFirst = [NSDate po_timeStringByDate:caseFromDate timeType:CurrentTimeTypeY_M_d_H_m];
        
        BOOL isSame = [currentLast isEqualToString:caseFirst];
        if (isSame) {
            return YES;
        }
        
        // 判断对照时间是否在当天
        if ([caseFromDate po_isEarlierThanDate:caseToDate]) {
            // 对照的时间段是正常顺序
            BOOL fromFlag = [currentFromDate po_isSectionInStartDate:caseFromDate andEndDate:caseToDate];
            BOOL toFlag = [currentToDate po_isSectionInStartDate:caseFromDate andEndDate:caseToDate];

            // 只有有一个在区间内，则不行
            if (fromFlag || toFlag) {
                return YES;
            }
            else {
                
                // 判断当前时间端是否在当天
                if ([currentFromDate po_isEarlierThanDate:currentToDate]) {
                    BOOL earlierFlag = [currentFromDate po_isEarlierThanDate:caseFromDate];
                    BOOL laterFlag = [currentToDate po_isLaterThanDate:caseToDate];
                    if (earlierFlag && laterFlag) {
                        // 当前时间段也属于正常顺序，且包围了对照时间段
                        return YES;
                    }
                }
                else {
                    BOOL otherFlag = [NSDate po_compareCurrentFromDate:caseFromDate currentToDate:caseToDate sectionCaseFromDate:currentFromDate caseToDate:currentToDate];
                    return otherFlag;
                }
            }
        }
        else {
            // 对照的时间段是跨日的
            
            // 取起始时间当天的最晚时间23:59:59
            NSDate *caseFromEndDate = [caseFromDate po_dateAtEndOfDay];

            BOOL from1Flag = [currentFromDate po_isSectionInStartDate:caseFromDate andEndDate:caseFromEndDate];
            BOOL to1Flag = [currentToDate po_isSectionInStartDate:caseFromDate andEndDate:caseFromEndDate];

            if (from1Flag || to1Flag) {
                return YES;
            }

            // 取结束时间当天的最早时间00:00:00
            NSDate *caseToStartDate = [caseToDate po_dateAtStartOfDay];

            BOOL from2Flag = [currentFromDate po_isSectionInStartDate:caseToStartDate andEndDate:caseToDate];
            BOOL to2Flag = [currentToDate po_isSectionInStartDate:caseToStartDate andEndDate:caseToDate];

            if (from2Flag || to2Flag) {
                return YES;
            }
            
            // 将跨日的时间+1天继续算一轮
            NSDate *caseToDate2 = [caseToDate po_dateByAddingDays:1];
            
            BOOL otherFlag = [NSDate po_compareCurrentFromDate:currentFromDate currentToDate:currentToDate sectionCaseFromDate:caseFromDate caseToDate:caseToDate2];
            return otherFlag;
        }
    }
    
    return NO;
}

- (BOOL)po_isWeekend {
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL)po_isWorkday {
    return ![self po_isWeekend];
}

@end
