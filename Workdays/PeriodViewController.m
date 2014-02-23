//
//  PeriodViewController.m
//  Workdays
//
//  Created by Andrey Fedorov on 16.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PeriodViewController.h"
#import "Workday.h"


@interface PeriodViewController ()
@property (nonatomic, weak) IBOutlet UITextField *workDaysField;
@property (nonatomic, weak) IBOutlet UITextField *freeDaysField;
@property (nonatomic, weak) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@end


@implementation PeriodViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addGestureRecognizer:self.tapGestureRecognizer];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.navigationItem.title = [dateFormatter stringFromDate:self.workday.startDate];
    if (self.workday.workDaysCount > 0) {
        self.workDaysField.text = [NSString stringWithFormat:@"%lu",
                                                             (unsigned long)self.workday.workDaysCount];
    }
    if (self.workday.freeDaysCount > 0) {
        self.freeDaysField.text = [NSString stringWithFormat:@"%lu",
                                                             (unsigned long)self.workday.freeDaysCount];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)toggleKeyboard:(UIGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.tableView];
    NSIndexPath *touchedIndexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    if (touchedIndexPath) {
        if (touchedIndexPath.section == 0) {
            [self.workDaysField becomeFirstResponder];
        } else if (touchedIndexPath.section == 1) {
            [self.freeDaysField becomeFirstResponder];
        }
        return;
    }

    if ([self.workDaysField isFirstResponder]) {
        [self.workDaysField resignFirstResponder];
        if ([self.workDaysField.text intValue] == 0) {
            self.workDaysField.text = @"";
        }
    } else if ([self.freeDaysField isFirstResponder]) {
        [self.freeDaysField resignFirstResponder];
        if ([self.freeDaysField.text intValue] == 0) {
            self.freeDaysField.text = @"";
        }
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
    if ([identifier isEqualToString:@"SavePeriod"]) {
        int workDays = 0, freeDays = 0;
        if ([self.workDaysField.text length] > 0) {
            workDays = [self.workDaysField.text intValue];
        }
        if ([self.freeDaysField.text length] > 0) {
            freeDays = [self.freeDaysField.text intValue];
        }
        if (workDays >= 0 && freeDays >= 0 && (workDays > 0 || freeDays > 0)) {
            self.workday.workDaysCount = (NSUInteger)workDays;
            self.workday.freeDaysCount = (NSUInteger)freeDays;
            return YES;
        }
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Длительность не заполнена"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}


- (IBAction)cancel
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
