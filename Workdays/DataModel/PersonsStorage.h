//
//  PersonsStorage.h
//  Workdays
//
//  Created by Andrey Fedorov on 24.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

@class Person;


typedef void (^PersonSaveCompletionBlock)(NSUInteger index, BOOL isNew);


@interface PersonsStorage : NSObject

+ (Person *)currentPerson;
+ (NSArray *)workdays;
+ (void)saveCurrentPerson:(PersonSaveCompletionBlock)onSave;

+ (Person *)personAtIndex:(NSUInteger)index;
+ (void)selectPersonAtIndex:(NSUInteger)index;
+ (void)selectNewPerson;
+ (void)swap:(NSUInteger)index1 and:(NSUInteger)index2;
+ (void)removePersonAtIndex:(NSUInteger)index;
+ (NSUInteger)size;

+ (BOOL)shouldRefreshPersonsList;

@end
