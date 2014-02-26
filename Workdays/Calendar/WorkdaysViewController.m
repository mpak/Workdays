//
// Created by Andrey Fedorov on 13.02.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "WorkdaysViewController.h"
#import "ActionForEditGestureRecognizer.h"
#import "Workday.h"
#import "PeriodViewController.h"
#import "NSDate+ComparisonAndDays.h"
#import "RDVCalendarDayCell.h"
#import "PersonsStorage.h"
#import "Person.h"


@interface WorkdaysViewController () <RDVCalendarViewDelegate>
@property (nonatomic, weak) NSArray *workdays;
@end


@implementation WorkdaysViewController
{
    NSUInteger _touchedIndex;
    NSDate *_firstDayOfMonth;
    NSDate *_lastDayOfMonth;
    DayType _days[31];
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

    NSDate *month = [self.calendarView.month date];
    _firstDayOfMonth = [month dateAtFirstDayOfMonth];
    _lastDayOfMonth = [month dateAtLastDayOfMonth];
    [self updateCells];

    [self.calendarView addGestureRecognizer:[ActionForEditGestureRecognizer gestureWithTarget:self
                                                                                       action:@selector(editPeriod:)]];
}


- (void)calendarView:(RDVCalendarView *)calendarView
    configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index
{
    if (_days[index] == WorkDay) {
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
        if (!workday) {
            workday = [[Workday alloc] init];
            workday.startDate = date;
        }
        UINavigationController *navigationController = segue.destinationViewController;
        PeriodViewController *periodViewController = navigationController.viewControllers[0];
        periodViewController.workday = workday;
    }
}


- (IBAction)savePeriod:(UIStoryboardSegue *)segue
{
    PeriodViewController *periodViewController = segue.sourceViewController;
    Workday *workday = periodViewController.workday;
    [[PersonsStorage currentPerson] setPeriodStartingAtDate:workday.startDate
                                                       work:workday.workDaysCount
                                                       free:workday.freeDaysCount];
    [self updateCells];
}


- (void)fillCells
{
    for (int i = 0; i < 31; i++) {
        _days[i] = UnknownDay;
    }
    if ([self.workdays count] == 0) return;

    Workday *min = nil;
    NSMutableArray *marks = [[NSMutableArray alloc] init];
    for (Workday *wd in self.workdays) {
        if ([wd.startDate lessOrEqual:_firstDayOfMonth]) {
            min = wd;
        } else if ([wd.startDate greaterThan:_firstDayOfMonth] && [wd.startDate lessOrEqual:_lastDayOfMonth]) {
            [marks addObject:wd];
        }
    }
    if (min) {
        [marks insertObject:min
                    atIndex:0];
    }

    int dayIndex = 0;
    if ([marks count] > 0) {
        NSDate *date = [[marks firstObject] startDate];
        if ([date greaterThan:_firstDayOfMonth]) {
            int n = 0;
            NSDate *tmp = nil;
            do {
                tmp = [NSDate dateWithTimeInterval:3600 * 24 * n++
                                         sinceDate:_firstDayOfMonth];
            } while ([tmp lessThan:date]);
            dayIndex = n - 1;
        }
    }

    while ([marks count] > 0) {
        min = [marks firstObject];
        [marks removeObjectAtIndex:0];
        NSDate *minDate = min.startDate;
        NSDate *maxDate = [[marks firstObject] startDate];

        NSUInteger work = min.workDaysCount;
        NSUInteger free = min.freeDaysCount;
        int n = 0;
        NSDate *tmp = nil;
        do {
            tmp = [NSDate dateWithTimeInterval:3600 * 24 * n++
                                     sinceDate:minDate];
            if (maxDate && [tmp equal:maxDate]) {
                break;
            }

            if (work == 0 && free == 0) {
                work = min.workDaysCount;
                free = min.freeDaysCount;
            }

            DayType dayType = UnknownDay;
            if (work > 0) {
                work--;
                dayType = WorkDay;
            } else if (free > 0) {
                free--;
                dayType = FreeDay;
            }
            if ([tmp greaterOrEqual:_firstDayOfMonth]) {
                _days[dayIndex] = dayType;
                dayIndex++;
            }
        } while ([tmp lessThan:_lastDayOfMonth]);
    }
}


- (void)updateCells
{
    [self fillCells];
    [[self calendarView] reloadData];
}


@end
