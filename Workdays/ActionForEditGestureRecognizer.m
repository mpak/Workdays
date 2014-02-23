//
//  ActionForEditGestureRecognizer.m
//  Workdays
//
//  Created by Andrey Fedorov on 17.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "ActionForEditGestureRecognizer.h"


@implementation ActionForEditGestureRecognizer

- (id)initWithTarget:(id)target
              action:(SEL)action
{
    self = [super initWithTarget:target
                          action:action];
    if (self) {
    }

    return self;
}


+ (instancetype)gestureWithTarget:(id)target
                           action:(SEL)action
{
    return [[[self class] alloc] initWithTarget:target
                                         action:action];
}


@end
