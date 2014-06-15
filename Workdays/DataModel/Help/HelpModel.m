//
// Created by Andrey Fedorov on 19.05.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "HelpModel.h"
#import "HelpView.h"


static NSString * const CalendarHelpWasDisplayed = @"CalendarHelpWasDisplayed";
static BOOL skipHelp = NO;


@implementation HelpModel

+ (void)skipNextHelp
{
    skipHelp = YES;
}

+ (void)showCalendarHelp
{
    if (skipHelp) {
        skipHelp = NO;
        return;
    }

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:CalendarHelpWasDisplayed]) return;
    [HelpView show:@"CalendarHelp"];
    [userDefaults setBool:YES forKey:CalendarHelpWasDisplayed];
    [userDefaults synchronize];
}

@end
