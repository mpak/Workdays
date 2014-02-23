//
//  PersonDetailViewController.h
//  Workdays
//
//  Created by Andrey Fedorov on 09.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//


#import "WorkdaysViewController.h"


@class Person;


@interface PersonDetailViewController : UIViewController
@property (nonatomic, strong) Person *person;
@end
