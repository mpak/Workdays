//
//  HelpView.m
//  Workdays
//
//  Created by Andrey Fedorov on 19.05.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "HelpView.h"


static BOOL displayed = NO;


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


- (void)awakeFromNib
{
    [super awakeFromNib];

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(20, self.bounds.size.height - 50, 30, 30);
    closeButton.titleLabel.font = [UIFont systemFontOfSize:30];
    closeButton.accessibilityLabel = NSLocalizedString(@"CLOSE_BUTTON", @"Close");
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"⊗" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
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
