//
//  ActionForEditGestureRecognizer.m
//  Workdays
//
//  Created by Andrey Fedorov on 17.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "ActionForEditGestureRecognizer.h"


@implementation ActionForEditGestureRecognizer

+ (void)applyTo:(id)view
     withTarget:(id)target
         action:(SEL)action
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target
                                                                                 action:action];
    tapGesture.numberOfTapsRequired = 2;
    [view addGestureRecognizer:tapGesture];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target
                                                                                                   action:action];
    [view addGestureRecognizer:longPressGesture];
}

@end
