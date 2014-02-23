//
// Created by Andrey Fedorov on 21.02.14.
// Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "NSIndexPath+Unsigned.h"


@implementation NSIndexPath (Unsigned)

- (NSUInteger)u_section
{
    return (NSUInteger)[self section];
}


- (NSUInteger)u_row
{
    return (NSUInteger)[self row];
}

@end
