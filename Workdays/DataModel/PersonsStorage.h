//
//  PersonsStorage.h
//  Workdays
//
//  Created by Andrey Fedorov on 24.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#include "Workday.h"


typedef void (^PersonSaveCompletionBlock)(NSUInteger index, BOOL isNew);


@interface PersonsStorage : NSObject

+ (NSString *)personName;
+ (NSString *)personDetails;

+ (void)selectNewPerson;
+ (void)selectPersonAtIndex:(NSUInteger)index;
+ (void)saveCurrentPerson:(PersonSaveCompletionBlock)onSave;
+ (void)setPersonName:(NSString *)name;
+ (void)swap:(NSUInteger)index1
         and:(NSUInteger)index2;
+ (void)removePersonAtIndex:(NSUInteger)index;

+ (Workday *)currentWorkday;
+ (void)selectWorkdayForDate:(NSDate *)date;
+ (void)saveCurrentWorkday;
+ (void)removeCurrentWorkday;
+ (DayType)dayTypeForDate:(NSDate *)date;

+ (NSUInteger)size;
+ (BOOL)shouldRefreshDisplayedData;

@end
