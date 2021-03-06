//
//  NSDate+BoolJudge.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSDate+BoolJudge.h"
#import "NSDate+Common.h"

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

/// ??????????????????????????????????????????????????????????????????????????????True
+ (BOOL)po_compareCurrentFromDate:(NSDate *)currentFromDate currentToDate:(NSDate *)currentToDate sectionCaseFromDate:(NSDate *)caseFromDate caseToDate:(NSDate *)caseToDate {
    
    if (caseFromDate && caseToDate) {
        
        // ??????????????????????????????
        NSString *currentLast = [NSDate po_timeStringByDate:currentToDate timeType:CurrentTimeTypeY_M_d_H_m];
        NSString *caseFirst = [NSDate po_timeStringByDate:caseFromDate timeType:CurrentTimeTypeY_M_d_H_m];
        
        BOOL isSame = [currentLast isEqualToString:caseFirst];
        if (isSame) {
            return YES;
        }
        
        // ?????????????????????????????????
        if ([caseFromDate po_isEarlierThanDate:caseToDate]) {
            // ?????????????????????????????????
            BOOL fromFlag = [currentFromDate po_isSectionInStartDate:caseFromDate andEndDate:caseToDate];
            BOOL toFlag = [currentToDate po_isSectionInStartDate:caseFromDate andEndDate:caseToDate];

            // ???????????????????????????????????????
            if (fromFlag || toFlag) {
                return YES;
            }
            else {
                
                // ????????????????????????????????????
                if ([currentFromDate po_isEarlierThanDate:currentToDate]) {
                    BOOL earlierFlag = [currentFromDate po_isEarlierThanDate:caseFromDate];
                    BOOL laterFlag = [currentToDate po_isLaterThanDate:caseToDate];
                    if (earlierFlag && laterFlag) {
                        // ??????????????????????????????????????????????????????????????????
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
            // ??????????????????????????????
            
            // ????????????????????????????????????23:59:59
            NSDate *caseFromEndDate = [caseFromDate po_dateAtEndOfDay];

            BOOL from1Flag = [currentFromDate po_isSectionInStartDate:caseFromDate andEndDate:caseFromEndDate];
            BOOL to1Flag = [currentToDate po_isSectionInStartDate:caseFromDate andEndDate:caseFromEndDate];

            if (from1Flag || to1Flag) {
                return YES;
            }

            // ????????????????????????????????????00:00:00
            NSDate *caseToStartDate = [caseToDate po_dateAtStartOfDay];

            BOOL from2Flag = [currentFromDate po_isSectionInStartDate:caseToStartDate andEndDate:caseToDate];
            BOOL to2Flag = [currentToDate po_isSectionInStartDate:caseToStartDate andEndDate:caseToDate];

            if (from2Flag || to2Flag) {
                return YES;
            }
            
            // ??????????????????+1??????????????????
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
