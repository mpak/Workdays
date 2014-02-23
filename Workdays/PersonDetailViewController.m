//
//  PersonDetailViewController.m
//  Workdays
//
//  Created by Andrey Fedorov on 09.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "Person.h"
#import "ActionForEditGestureRecognizer.h"
#import "CalendarPageViewController.h"


@interface PersonDetailViewController () <UITextFieldDelegate, WorkdaysViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UIView *calendarContainer;
@end


@implementation PersonDetailViewController
{
    UILabel *_nameLabel;
    IBOutlet UITextField *_nameField;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _person = [[Person alloc] initWithName:@""];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    _nameLabel = [[UILabel alloc] initWithFrame:_nameField.frame];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.userInteractionEnabled = YES;
    [_nameLabel addGestureRecognizer:[ActionForEditGestureRecognizer gestureWithTarget:self
                                                                                action:@selector(editName)]];

    if ([self.person.name length] == 0) {
        // try prevent lag on first keyboard appearance
        [_nameField performSelectorOnMainThread:@selector(becomeFirstResponder)
                                     withObject:nil
                                  waitUntilDone:NO];
    } else {
        [self updateNameLabel];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    // back button clicked
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        if ([self.navigationItem.titleView isFirstResponder]) {
            self.person.name = _nameField.text;
        }
        [self performSegueWithIdentifier:@"SavePerson"
                                  sender:nil];
    }
    [super viewWillDisappear:animated];
}


- (void)updateNameLabel
{
    _nameLabel.text = self.person.name;
    UIFontDescriptorSymbolicTraits symTraits;
    if ([_nameLabel.text length] > 0) {
        _nameLabel.textColor = [UIColor blackColor];
        symTraits = UIFontDescriptorClassSansSerif;
    } else {
        _nameLabel.text = @"Имя";
        _nameLabel.textColor = [UIColor lightGrayColor];
        symTraits = UIFontDescriptorTraitItalic;
    }
    UIFontDescriptor *fontDescriptor = [_nameLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:symTraits];
    _nameLabel.font = [UIFont fontWithDescriptor:fontDescriptor
                                            size:0];
    self.navigationItem.titleView = _nameLabel;
}


- (IBAction)editName
{
    _nameField.text = self.person.name;
    self.navigationItem.titleView = _nameField;
    [_nameField becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.navigationItem.titleView isFirstResponder]) {
        [self.navigationItem.titleView resignFirstResponder];
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text = [_nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.person.name = text;
    [self updateNameLabel];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EmbedCalendar"]) {
        CalendarPageViewController *pageController = segue.destinationViewController;
        pageController.passDelegate = self;
        pageController.passWorkdays = self.person.workdays;
    }
}


- (void)workdaysViewController:(WorkdaysViewController *)controller
          finishEditingWorkday:(Workday *)workday
{
    [self.person setPeriodStartingAtDate:workday.startDate
                                    work:workday.workDaysCount
                                    free:workday.freeDaysCount];
    if (self.person.modified) {
        controller.workdays = self.person.workdays;
        [controller updateCells];
    }
}

@end
