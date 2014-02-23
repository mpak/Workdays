//
//  ActionForEditGestureRecognizer.h
//  Workdays
//
//  Created by Andrey Fedorov on 17.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//



@interface ActionForEditGestureRecognizer : UILongPressGestureRecognizer

+ (instancetype)gestureWithTarget:(id)target
                           action:(SEL)action;

@end
