//
//  Person.m
//  Workdays
//
//  Created by Andrey Fedorov on 09.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "Person.h"
#import "NSDate+ComparisonAndDays.h"


@implementation Person


- (void)setName:(NSString *)name
{
    if (!name || [name length] == 0) return;
    if (![_name isEqualToString:name]) {
        _name = name;
        _modified = YES; // TODO: move this flag to PersonsStorage?
    }
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"";
        _workdays = [[NSMutableArray alloc] init];
        _modified = NO;
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name
                 forKey:@"name"];
    [coder encodeObject:self.workdays
                 forKey:@"workdays"];
    _modified = NO;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        _workdays = [coder decodeObjectForKey:@"workdays"];
        _modified = NO;
    }
    return self;
}


- (DayType)dayTypeForDate:(NSDate *)date
{
    Workday *workday = nil;
    NSDate *today = [[NSDate date] dateWithoutTime];
    for (Workday *wd in self.workdays) {
        if ([wd.startDate lessOrEqual:today]) {
            workday = wd;
        } else {
            break;
        }
    }
    if (!workday) {
        return UnknownDay;
    }

    NSUInteger todayS = (NSUInteger)[today timeIntervalSince1970];
    NSUInteger dateS = (NSUInteger)[date timeIntervalSince1970];
    
    NSUInteger diff = (todayS - dateS) / (3600 * 24);
    NSUInteger totalDays = workday.workDaysCount + workday.freeDaysCount;
    NSUInteger remainder = diff % totalDays;

    if (remainder < workday.workDaysCount) {
        return WorkDay;
    }
    return FreeDay;
}


- (void)setPeriodStartingAtDate:(NSDate *)date
                           work:(NSUInteger)work
                           free:(NSUInteger)free
{
    Workday *workday = nil;
    for (Workday *wd in _workdays) {
        if ([wd.startDate isEqualToDate:date]) {
            workday = wd;
            break;
        }
    }
    if (!workday) {
        workday = [[Workday alloc] init];
        workday.startDate = date;
        [_workdays addObject:workday];
        [_workdays sortUsingDescriptors:[Workday sortDescriptors]];
        _modified = YES;
    }
    if (workday.workDaysCount != work || workday.freeDaysCount != free) {
        workday.workDaysCount = work;
        workday.freeDaysCount = free;
        _modified = YES;
    }

}


@end
