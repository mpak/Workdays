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

- (instancetype)initWithName:(NSString *)name;
- (DayType)dayTypeForDate:(NSDate *)date;
- (void)setPeriodStartingAtDate:(NSDate *)date
                           work:(NSUInteger)work
                           free:(NSUInteger)free;

@end
