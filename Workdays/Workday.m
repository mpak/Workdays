//
//  Workday.m
//  Workdays
//
//  Created by Andrey Fedorov on 09.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "Workday.h"


@implementation Workday


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.startDate
                 forKey:@"startDate"];
    [coder encodeInteger:self.workDaysCount
                  forKey:@"workDaysCount"];
    [coder encodeInteger:self.freeDaysCount
                  forKey:@"freeDaysCount"];
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _startDate = [coder decodeObjectForKey:@"startDate"];
        _workDaysCount = (NSUInteger)[coder decodeIntegerForKey:@"workDaysCount"];
        _freeDaysCount = (NSUInteger)[coder decodeIntegerForKey:@"freeDaysCount"];
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %@ %lu %lu>",
                                      NSStringFromClass([self class]),
                                      self.startDate,
                                      (unsigned long)self.workDaysCount,
                                      (unsigned long)self.freeDaysCount
    ];
}


- (id)copyWithZone:(NSZone *)zone
{
    Workday *wd = [[[self class] allocWithZone:zone] init];
    wd.startDate = self.startDate;
    wd.workDaysCount = self.workDaysCount;
    wd.freeDaysCount = self.freeDaysCount;
    return wd;
}


+ (NSArray *)sortDescriptors
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                               ascending:YES];
    return @[descriptor];
}


@end
