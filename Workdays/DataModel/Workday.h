//
//  Workday.h
//  Workdays
//
//  Created by Andrey Fedorov on 09.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

typedef NS_ENUM(NSUInteger, DayType) {
    UnknownDay,
    FreeDay,
    WorkDay,
};


@interface Workday : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSUInteger workDaysCount;
@property (nonatomic, assign) NSUInteger freeDaysCount;

+ (NSArray *)sortDescriptors;

@end
