//
//  PersonsStorage.m
//  Workdays
//
//  Created by Andrey Fedorov on 24.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PersonsStorage.h"
#import "Person.h"
#import "NSDate+ComparisonAndDays.h"


static NSMutableArray *persons = nil;
static Person *currentPerson = nil;
static NSUInteger currentPersonIndex = NSNotFound;
static Workday *currentWorkday = nil;
static NSUInteger currentWorkdayIndex = NSNotFound;


@implementation PersonsStorage


+ (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths firstObject] stringByAppendingPathComponent:@"workdays.dat"];
}


+ (void)initialize
{
    NSString *filePath = [self.class dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        persons = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    if (!persons) {
        persons = [[NSMutableArray alloc] init];
    }
}


#pragma mark - Exact person methods

+ (NSString *)personName
{
    return [currentPerson name];
}


+ (void)setPersonName:(NSString *)name
{
    currentPerson.name = name;
}


+ (NSString *)personDetails
{
    NSString *state = @"";
    NSUInteger index = 0;
    switch([currentPerson dayTypeForDate:[NSDate date] index:&index]) {
        case WorkDay: state = NSLocalizedString(@"WORKDAY_LABEL", @"Workday label on persons list"); break;
        case FreeDay: state = NSLocalizedString(@"RESTDAY_LABEL", @"Restday label on persons list"); break;
        case UnknownDay:break;
    }
    if (index) {
        state = [state stringByAppendingFormat:@" %u", index];
    }
    return state;
}


+ (void)selectNewPerson
{
    currentPersonIndex = NSNotFound;
    currentPerson = [[Person alloc] init];
}


+ (void)selectPersonAtIndex:(NSUInteger)index
{
    currentPersonIndex = index;
    currentPerson = persons[index];
}


+ (void)swap:(NSUInteger)index1
         and:(NSUInteger)index2
{
    [persons exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    [self save];
}


+ (void)removePersonAtIndex:(NSUInteger)index
{
    [persons removeObjectAtIndex:index];
    [self save];
}


+ (void)saveCurrentPerson:(PersonSaveCompletionBlock)onSave
{
    if (currentPerson.modified) {
        BOOL isNew = NO;
        NSUInteger index;
        if (currentPersonIndex == NSNotFound) {
            isNew = YES;
            index = [self size];
            [persons addObject:currentPerson];
        } else {
            index = currentPersonIndex;
        }
        [self save];
        onSave(index, isNew);
    }
}


#pragma mark - Exact workday methods

+ (void)selectWorkdayForDate:(NSDate *)date
{
    currentWorkdayIndex = [[currentPerson workdays] indexOfObjectPassingTest:^BOOL(Workday *workday, NSUInteger idx, BOOL *stop)
    {
        return [workday.startDate equal:date];
    }];
    if (currentWorkdayIndex == NSNotFound) {
        currentWorkday = [[Workday alloc] init];
        currentWorkday.startDate = date;
    } else {
        currentWorkday = [currentPerson.workdays[currentWorkdayIndex] copy];
    }
}


+ (Workday *)currentWorkday
{
    return currentWorkday;
}


+ (void)saveCurrentWorkday
{
    [currentPerson setPeriodStartingAtDate:currentWorkday.startDate
                                      work:currentWorkday.workDaysCount
                                      free:currentWorkday.freeDaysCount];
    if (currentPerson.modified) {
        [self save];
    }
}


+ (void)removeCurrentWorkday
{
    [currentPerson removePeriodAtIndex:currentWorkdayIndex];
    currentWorkday = nil;
    currentWorkdayIndex = NSNotFound;
    [self save];
}


+ (DayType)dayTypeForDate:(NSDate *)date
{
    return [currentPerson dayTypeForDate:date];
}


#pragma mark - Generic methods

+ (NSUInteger)size
{
    return [persons count];
}


+ (void)save
{
    [NSKeyedArchiver archiveRootObject:persons
                                toFile:[self dataFilePath]];
}


+ (BOOL)shouldRefreshDisplayedData
{
    static NSDate *lastUpdateDay = nil;
    if (!lastUpdateDay) {
        lastUpdateDay = [[NSDate date] dateWithoutTime];
        return NO;
    }
    NSDate *today = [[NSDate date] dateWithoutTime];
    return [today greaterThan:lastUpdateDay];
}

@end
