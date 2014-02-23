//
//  CalendarPageViewController.h
//  Workdays
//
//  Created by Andrey Fedorov on 16.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//


@interface CalendarPageViewController : UIPageViewController

@property (nonatomic, weak) NSArray *passWorkdays;
@property (nonatomic, weak) id passDelegate;

@end
