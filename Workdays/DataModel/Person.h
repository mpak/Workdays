//
//  Person.h
//  Workdays
//
//  Created by Andrey Fedorov on 09.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "Workday.h"


@interface Person : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong, readonly) NSMutableArray *workdays;
@property (nonatomic, readonly) BOOL modified;

- (DayType)dayTypeForDate:(NSDate *)date;
- (DayType)dayTypeForDate:(NSDate *)date
                    index:(NSUInteger *)index;
- (void)setPeriodStartingAtDate:(NSDate *)date
                           work:(NSUInteger)work
                           free:(NSUInteger)free;

@end
