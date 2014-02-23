//
// Created by Andrey Fedorov on 13.02.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "RDVCalendarViewController.h"


@class WorkdaysViewController;
@class Workday;


@protocol WorkdaysViewControllerDelegate
- (void)workdaysViewController:(WorkdaysViewController *)controller
          finishEditingWorkday:(Workday *)workday;
@end


@interface WorkdaysViewController : RDVCalendarViewController

@property (nonatomic, weak) NSArray *workdays;
@property (nonatomic, weak) id <WorkdaysViewControllerDelegate> delegate;

- (void)updateCells;

@end
