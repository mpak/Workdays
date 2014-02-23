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
    return [self lessThan:date] || [self equal:date];
}


- (BOOL)greaterThan:(NSDate *)date
{
    return [self compare:date] == NSOrderedDescending;
}


- (BOOL)greaterOrEqual:(NSDate *)date
{
    return [self greaterThan:date] || [self equal:date];
}


- (NSCalendar *)currentCalendar
{
    static NSCalendar *currentCalendar = nil;
    if (!currentCalendar) {
        currentCalendar = [NSCalendar currentCalendar];
    }
    return currentCalendar;
}


- (NSDate *)dateWithDayOfMonth:(NSInteger)day
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                               fromDate:self];
    if (day > 0) {
        components.day = day;
    }
    return [calendar dateFromComponents:components];
}


- (NSDate *)dateWithoutTime
{
    return [self dateWithDayOfMonth:0];
}


- (NSDate *)firstDaysOfMonth
{
    return [self dateWithDayOfMonth:1];
}


- (NSDate *)lastDayOfMonth
{
    NSRange daysRange = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                                           inUnit:NSCalendarUnitMonth
                                                          forDate:self];
    return [self dateWithDayOfMonth:daysRange.length];
}

@end
