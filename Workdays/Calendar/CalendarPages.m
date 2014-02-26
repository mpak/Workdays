//
//  CalendarPages.m
//  Workdays
//
//  Created by Andrey Fedorov on 17.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "CalendarPages.h"
#import "RDVCalendarViewController.h"
#import "WorkdaysViewController.h"


static NSString *const CalendarStoryboardIdentifier = @"WorkdaysCalendar";


@implementation CalendarPages


- (UIViewController *)initialViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    WorkdaysViewController *controller
        = [storyboard instantiateViewControllerWithIdentifier:CalendarStoryboardIdentifier];
    return controller;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    WorkdaysViewController *controller
        = [pageViewController.storyboard instantiateViewControllerWithIdentifier:CalendarStoryboardIdentifier];

    WorkdaysViewController *old = (WorkdaysViewController *)viewController;
    controller.month = [[[old calendarView] month] month] - 1;
    return controller;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    WorkdaysViewController *controller
        = [pageViewController.storyboard instantiateViewControllerWithIdentifier:CalendarStoryboardIdentifier];

    WorkdaysViewController *old = (WorkdaysViewController *)viewController;
    controller.month = [[[old calendarView] month] month] + 1;
    return controller;
}


@end
