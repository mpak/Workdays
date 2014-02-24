//
// Created by Andrey Fedorov on 22.02.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//


@interface NSDate (ComparisonAndDays)

- (BOOL)equal:(NSDate *)date;
- (BOOL)lessThan:(NSDate *)date;
- (BOOL)lessOrEqual:(NSDate *)date;
- (BOOL)greaterThan:(NSDate *)date;
- (BOOL)greaterOrEqual:(NSDate *)date;

- (NSDate *)dateWithoutTime;
- (NSDate *)dateAtFirstDayOfMonth;
- (NSDate *)dateAtLastDayOfMonth;

@end
