//
//  CalendarPageViewController.m
//  Workdays
//
//  Created by Andrey Fedorov on 16.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "CalendarPageViewController.h"
#import "CalendarPages.h"


@implementation CalendarPageViewController
{
    CalendarPages *_pages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _pages = [[CalendarPages alloc] init];
    self.dataSource = _pages;
    self.delegate = _pages;

    [self disableCurlOnTap];

    [self setViewControllers:@[[_pages initialViewController]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}


- (void)disableCurlOnTap
{
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            gesture.enabled = NO;
        }
    }
}

@end
