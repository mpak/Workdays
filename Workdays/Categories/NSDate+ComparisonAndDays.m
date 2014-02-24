//
// Created by Andrey Fedorov on 22.02.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "NSDate+ComparisonAndDays.h"


@implementation NSDate (ComparisonAndDays)

- (BOOL)equal:(NSDate *)date
{
    return [self compare:date] == NSOrderedSame;
}


- (BOOL)lessThan:(NSDate *)date
{
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)lessOrEqual:(NSDate *)date
{
    return [self compare:date] != NSOrderedDescending;
}


- (BOOL)greaterThan:(NSDate *)date
{
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL)greaterOrEqual:(NSDate *)date
{
    return [self compare:date] != NSOrderedAscending;
}


- (NSDate *)dateWithDayOfMonth:(NSInteger)day
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                      fromDate:self];
    if (day > 0) {
        components.day = day;
    }
    return [currentCalendar dateFromComponents:components];
}


- (NSDate *)dateWithoutTime
{
    return [self dateWithDayOfMonth:0];
}


- (NSDate *)dateAtFirstDayOfMonth
{
    return [self dateWithDayOfMonth:1];
}


- (NSDate *)dateAtLastDayOfMonth
{
    NSRange daysRange = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                                           inUnit:NSCalendarUnitMonth
                                                          forDate:self];
    return [self dateWithDayOfMonth:daysRange.length];
}

@end
