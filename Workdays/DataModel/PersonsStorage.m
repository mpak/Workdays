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
static NSUInteger currentIndex = NSUIntegerMax;


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


+ (Person *)personAtIndex:(NSUInteger)index
{
    return persons[index];
}


+ (void)selectPersonAtIndex:(NSUInteger)index
{
    if (index == NSUIntegerMax) {
        currentIndex = [self size];
        currentPerson = [[Person alloc] init];
    } else {
        currentIndex = index;
        currentPerson = persons[index];
    }
}


+ (void)selectNewPerson
{
    [self selectPersonAtIndex:NSUIntegerMax];
}


+ (void)swap:(NSUInteger)index1
         and:(NSUInteger)index2
{
    Person *person = persons[index1];
    persons[index1] = persons[index2];
    persons[index2] = person;
    [self save];
}


+ (void)removePersonAtIndex:(NSUInteger)index
{
    [persons removeObjectAtIndex:index];
    [self save];
}


+ (NSUInteger)size
{
    return [persons count];
}


+ (Person *)currentPerson
{
    return currentPerson;
}


+ (NSArray *)workdays
{
    return [currentPerson workdays];
}


+ (void)saveCurrentPerson:(PersonSaveCompletionBlock)onSave
{
    if (currentPerson.modified) {
        BOOL isNew = NO;
        NSUInteger index = [self size];
        if (currentIndex == index) {
            isNew = YES;
            [persons addObject:currentPerson];
        } else {
            index = currentIndex;
        }
        [self save];
        onSave(index, isNew);
    }
}


+ (void)save
{
    [NSKeyedArchiver archiveRootObject:persons
                                toFile:[self dataFilePath]];
}


+ (BOOL)shouldRefreshPersonsList
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
