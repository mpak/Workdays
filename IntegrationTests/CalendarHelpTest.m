//
//  CalendarHelpTest.m
//  Workdays
//
//  Created by Andrey Fedorov on 05.06.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import <Subliminal/Subliminal.h>


#define TAP(label) \
    [self recordLastKnownFile:__FILE__ line:__LINE__]; \
    [[SLElement elementWithAccessibilityLabel:label] tap];


@interface CalendarHelpTest : SLTest

@end

@implementation CalendarHelpTest

- (void)setUpTest
{
    TAP(@"Edit");
    [self wait:0.5];
}

- (void)setUpTestCaseWithSelector:(SEL)testCaseSelector
{
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
    TAP(@"Insert New");
}


- (void)testHelpNotAppearsOnBackButton
{
    TAP(@"Back");
    TAP(@"Insert New");
    TAP(@"5");
    TAP(@"Close");
    TAP(@"Back");
}

- (void)testHelpAppearsAfterBack
{
    SLTextField *nameField = [SLTextField elementWithAccessibilityLabel:@"Name"];
    [nameField setText:@"Alice"];
    TAP(@"Back");
    TAP(@"Done");
    TAP(@"Alice");
    TAP(@"Close");
    TAP(@"Back");
    TAP(@"Edit");
}

- (void)testHelpCancelsPeriodEditing
{
    SLElement *element = [SLElement elementWithAccessibilityLabel:@"5"];
    [element touchAndHoldWithDuration:2];
    TAP(@"Close");
    TAP(@"Back");
}

@end
