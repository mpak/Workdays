//
//  HelpView.m
//  Workdays
//
//  Created by Andrey Fedorov on 19.05.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "HelpView.h"


@interface HelpView()
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation HelpView


+ (void)show:(NSString *)nibName
{
    HelpView *help = [[NSBundle mainBundle] loadNibNamed:nibName
                                                   owner:nil
                                                 options:nil][0];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:help];
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
        [self.closeButton setTitle:@"⊗" forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
    }
    return self;
}


- (IBAction)close
{
    [self removeFromSuperview];
}

@end
