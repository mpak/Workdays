//
// Created by Andrey Fedorov on 13.02.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "WorkdaysViewController.h"
#import "ActionForEditGestureRecognizer.h"
#import "Workday.h"
#import "RDVCalendarDayCell.h"
#import "PersonsStorage.h"
#import "HelpView.h"


@implementation WorkdaysViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self calendarView] reloadData];
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
    if ([PersonsStorage dayTypeForDate:date] == WorkDay) {
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
    if ([ActionForEditGestureRecognizer emitted:gesture]) {
        if ([HelpView displayed]) return;
        CGPoint touchPoint = [gesture locationInView:self.calendarView];
        NSUInteger touchedIndex = [self.calendarView indexForDayCellAtPoint:touchPoint];
        if (touchedIndex != NSNotFound) {
            [self performSegueWithIdentifier:@"EditPeriod"
                                      sender:[self.calendarView dateForIndex:touchedIndex]];
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)date
{
    if ([segue.identifier isEqualToString:@"EditPeriod"]) {
        [PersonsStorage selectWorkdayForDate:date];
    }
}

@end
