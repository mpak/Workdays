//
//  PersonDetailViewController.m
//  Workdays
//
//  Created by Andrey Fedorov on 09.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "ActionForEditGestureRecognizer.h"
#import "PersonsStorage.h"
#import "HelpModel.h"


@interface PersonDetailViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIView *calendarContainer;
@end


@implementation PersonDetailViewController
{
    UILabel *_nameLabel;
    IBOutlet UITextField *_nameField;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    _nameLabel = [[UILabel alloc] initWithFrame:_nameField.frame];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.userInteractionEnabled = YES;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.minimumScaleFactor = 0.6;
    [ActionForEditGestureRecognizer applyTo:_nameLabel
                                 withTarget:self
                                     action:@selector(editName)];

    if ([[PersonsStorage personName] length] == 0) {
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
            [PersonsStorage setPersonName:_nameField.text];
        }
        [self performSegueWithIdentifier:@"SavePerson"
                                  sender:nil];
    }
    [super viewWillDisappear:animated];
}


- (void)updateNameLabel
{
    _nameLabel.text = [PersonsStorage personName];
    UIFontDescriptorSymbolicTraits symTraits;
    if ([_nameLabel.text length] > 0) {
        _nameLabel.textColor = [UIColor blackColor];
        symTraits = UIFontDescriptorClassSansSerif;
    } else {
        _nameLabel.text = NSLocalizedString(@"NAME_PLACEHOLDER", @"Name placeholder");
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
    _nameField.text = [PersonsStorage personName];
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
    [PersonsStorage setPersonName:text];
    [self updateNameLabel];
    [HelpModel showCalendarHelp];
}


@end
