//
//  PeriodViewController.h
//  Workdays
//
//  Created by Andrey Fedorov on 16.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//



@interface PeriodViewController : UITableViewController

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSUInteger workDays;
@property (nonatomic, assign) NSUInteger freeDays;

@end
