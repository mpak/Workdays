//
// Created by Andrey Fedorov on 19.05.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "HelpModel.h"
#import "HelpView.h"


static NSString * const CalendarHelpWasDisplayed = @"CalendarHelpWasDisplayed";

@implementation HelpModel

+ (void)showCalendarHelp
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CalendarHelpWasDisplayed]) return;

    [HelpView show:@"CalendarHelp"];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CalendarHelpWasDisplayed];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
