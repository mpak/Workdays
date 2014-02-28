//
// Created by Andrey Fedorov on 13.02.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "WorkdaysViewController.h"
#import "ActionForEditGestureRecognizer.h"
#import "Workday.h"
#import "PeriodViewController.h"
#import "RDVCalendarDayCell.h"
#import "PersonsStorage.h"
#import "Person.h"


@interface WorkdaysViewController () <RDVCalendarViewDelegate>
@property (nonatomic, weak) NSArray *workdays;
@end


@implementation WorkdaysViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.workdays = [PersonsStorage workdays];

    [ActionForEditGestureRecognizer applyTo:self.calendarView
                                 withTarget:self
                                     action:@selector(editPeriod:)];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)applicationWillEnterForeground
{
    if ([PersonsStorage shouldRefreshDisplayedData]) {
        [[self calendarView] reloadData];
    }
}


- (void)calendarView:(RDVCalendarView *)calendarView
    configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index
{
    NSDate *date = [self.calendarView dateForIndex:index];
    if ([[PersonsStorage currentPerson] dayTypeForDate:date] == WorkDay) {
        dayCell.highlighted = YES;
    }
}


- (BOOL)   calendarView:(RDVCalendarView *)calendarView
shouldSelectCellAtIndex:(NSInteger)index
{
    return NO;
}


- (void)editPeriod:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint touchPoint = [gesture locationInView:self.calendarView];
        NSUInteger touchedIndex = [self.calendarView indexForDayCellAtPoint:touchPoint];
        [self performSegueWithIdentifier:@"EditPeriod"
                                  sender:[self.calendarView dateForIndex:touchedIndex]];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)date
{
    if ([segue.identifier isEqualToString:@"EditPeriod"]) {
        Workday *workday = nil;
        for (Workday *wd in self.workdays) {
            if ([wd.startDate isEqualToDate:date]) {
                workday = wd;
                break;
            }
        }
        UINavigationController *navigationController = segue.destinationViewController;
        PeriodViewController *periodViewController = navigationController.viewControllers[0];
        if (workday) {
            periodViewController.date = workday.startDate;
            periodViewController.workDays = workday.workDaysCount;
            periodViewController.freeDays = workday.freeDaysCount;
        } else {
            periodViewController.date = date;
        }
    }
}


- (IBAction)savePeriod:(UIStoryboardSegue *)segue
{
    PeriodViewController *periodViewController = segue.sourceViewController;
    [[PersonsStorage currentPerson] setPeriodStartingAtDate:periodViewController.date
                                                       work:periodViewController.workDays
                                                       free:periodViewController.freeDays];
    [[self calendarView] reloadData];
}


@end
