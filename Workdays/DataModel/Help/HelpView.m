//
//  HelpView.m
//  Workdays
//
//  Created by Andrey Fedorov on 19.05.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "HelpView.h"


static BOOL displayed = NO;


@interface HelpView()
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation HelpView


+ (void)show:(NSString *)nibName
{
    displayed = YES;
    HelpView *help = [[NSBundle mainBundle] loadNibNamed:nibName
                                                   owner:nil
                                                 options:nil][0];
    help.alpha = 0.0;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:help];
    [UIView animateWithDuration:0.3 animations:^{
        help.alpha = 1.0;
    }];
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.closeButton.frame = CGRectMake(20, self.bounds.size.height - 50, 30, 30);
        self.closeButton.titleLabel.font = [UIFont systemFontOfSize:30];
        [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin;
        self.closeButton.accessibilityLabel = NSLocalizedString(@"CLOSE_BUTTON", @"Close");
        [self.closeButton setTitle:@"⊗" forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
    }
    return self;
}


+ (BOOL)displayed
{
    return displayed;
}


- (IBAction)close
{
    [self removeFromSuperview];
    displayed = NO;
}

@end
