//
//  PeriodViewController.m
//  Workdays
//
//  Created by Andrey Fedorov on 16.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PeriodViewController.h"


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
    self.navigationItem.title = [dateFormatter stringFromDate:self.date];
    if (self.workDays > 0) {
        self.workDaysField.text = [NSString stringWithFormat:@"%lu",
                                                             (unsigned long)self.workDays];
    }
    if (self.freeDays > 0) {
        self.freeDaysField.text = [NSString stringWithFormat:@"%lu",
                                                             (unsigned long)self.freeDays];
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
        self.workDays = (NSUInteger)[self.workDaysField.text intValue];
        self.freeDays = (NSUInteger)[self.freeDaysField.text intValue];
        if (!self.workDays && !self.freeDays) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"Длительность не заполнена"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return NO;
        }
    }
    return YES;
}


- (IBAction)cancel
{
    // FIXME: on cancel already selected cell will be deselected,
    // FIXME replace with unwind segue?
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
