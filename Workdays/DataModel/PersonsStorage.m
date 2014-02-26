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


@interface PersonsStorage ()
@property (nonatomic, strong, readwrite) Person *currentPerson;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong, readonly) NSMutableArray *persons;
@end


@implementation PersonsStorage


+ (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths firstObject] stringByAppendingPathComponent:@"workdays.dat"];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *filePath = [self.class dataFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            _persons = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        }
        if (!_persons) {
            _persons = [[NSMutableArray alloc] init];
        }
        _currentPerson = nil;
        _currentIndex = NSUIntegerMax;
    }
    return self;
}


+ (instancetype)instance
{
    static PersonsStorage *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[PersonsStorage alloc] init];
    });
    return instance;
}


+ (NSMutableArray *)persons
{
    return [[self instance] persons];
}


+ (Person *)personAtIndex:(NSUInteger)index
{
    return [[[self instance] persons] objectAtIndex:index];
    return nil;
}


+ (void)selectPersonAtIndex:(NSUInteger)index
{
    Person *person;
    if (index == NSUIntegerMax) {
        person = [[Person alloc] init];
        index = [self size];
    } else {
        person = [[self persons] objectAtIndex:index];
    }
    [[self instance] setCurrentIndex:index];
    [[self instance] setCurrentPerson:person];
}


+ (void)selectNewPerson
{
    [self selectPersonAtIndex:NSUIntegerMax];
}


+ (void)swap:(NSUInteger)index1
         and:(NSUInteger)index2
{
    Person *person = [self persons][index1];
    [self persons][index1] = [self persons][index2];
    [self persons][index2] = person;
    [self save];
}


+ (void)removePersonAtIndex:(NSUInteger)index
{
    [[self persons] removeObjectAtIndex:index];
    [self save];
}


+ (NSUInteger)size
{
    return [[self persons] count];
}


+ (Person *)currentPerson
{
    return [[self instance] currentPerson];
}


+ (NSArray *)workdays
{
    return [[self currentPerson] workdays];
}


+ (void)saveCurrentPerson:(PersonSaveCompletionBlock)onSave
{
    Person *person = [[self instance] currentPerson];
    if (person.modified) {
        BOOL isNew = NO;
        NSUInteger index = [self size];
        if ([[self instance] currentIndex] == index) {
            isNew = YES;
            [[self persons] addObject:person];
        } else {
            index = [[self instance] currentIndex];
        }
        [self save];
        onSave(index, isNew);
    }
}


+ (void)save
{
    [NSKeyedArchiver archiveRootObject:self.persons
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
