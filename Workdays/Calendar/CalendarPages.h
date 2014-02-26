//
//  CalendarPages.h
//  Workdays
//
//  Created by Andrey Fedorov on 17.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//


@interface CalendarPages : NSObject <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, assign) NSInteger month;

- (UIViewController *)initialViewController;

@end
