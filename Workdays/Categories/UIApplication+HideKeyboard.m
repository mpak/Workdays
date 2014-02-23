//
// Created by Andrey Fedorov on 16.02.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "UIApplication+HideKeyboard.h"


@implementation UIApplication (HideKeyboard)

+ (void)hk_hideKeyboard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

@end
