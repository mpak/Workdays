//
//  PeriodViewController.m
//  Workdays
//
//  Created by Andrey Fedorov on 16.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PeriodViewController.h"
#import "PersonsStorage.h"


@interface PeriodViewController () <UIActionSheetDelegate>
@property (nonatomic, weak) IBOutlet UITextField *workDaysField;
@property (nonatomic, weak) IBOutlet UITextField *freeDaysField;
@property (nonatomic, weak) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) Workday *workday;
@end


@implementation PeriodViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.workday = [PersonsStorage currentWorkday];

    [self.view addGestureRecognizer:self.tapGestureRecognizer];

    if (self.workday.workDaysCount || self.workday.freeDaysCount) {
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                      target:self
                                                                                      action:@selector(deletePeriod)];
        [self.navigationController setToolbarHidden:NO];
        [self setToolbarItems:@[deleteButton]];
    }

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


- (void)deletePeriod
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"REMOVE_PERIOD_QUESTION", @"Remove period title")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"CANCEL_PERIOD_REMOVE", @"Cancel button")
                                         destructiveButtonTitle:NSLocalizedString(@"CONFIRM_PERIOD_REMOVE", "Confirm removing button")
                                              otherButtonTitles:nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showFromToolbar:self.navigationController.toolbar];
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
        self.workday.workDaysCount = (NSUInteger)[self.workDaysField.text intValue];
        self.workday.freeDaysCount = (NSUInteger)[self.freeDaysField.text intValue];
        if (!self.workday.workDaysCount && !self.workday.freeDaysCount) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:NSLocalizedString(@"EMPTY_DURATION_ERROR", @"Empty duration error message")
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
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"RemovePeriod" sender:nil];
    }
}

@end
