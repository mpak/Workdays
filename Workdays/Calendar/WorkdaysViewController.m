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
{
    NSUInteger _touchedIndex;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _touchedIndex = NSNotFound;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.workdays = [PersonsStorage workdays];

    [self.calendarView addGestureRecognizer:[ActionForEditGestureRecognizer gestureWithTarget:self
                                                                                       action:@selector(editPeriod:)]];
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


- (void)editPeriod:(ActionForEditGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [gesture locationInView:self.calendarView];
        _touchedIndex = [self.calendarView indexForDayCellAtPoint:touchPoint];
        if (_touchedIndex != NSNotFound) {
            [self.calendarView selectDayCellAtIndex:_touchedIndex
                                           animated:YES];
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if (_touchedIndex != NSNotFound) {
            [self.calendarView deselectDayCellAtIndex:_touchedIndex
                                             animated:YES];
            [self performSegueWithIdentifier:@"EditPeriod"
                                      sender:[self.calendarView dateForIndex:_touchedIndex]];
        }
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
