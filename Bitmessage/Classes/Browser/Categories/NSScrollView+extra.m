//
//  NSScrollView+extra.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/24/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSScrollView+extra.h"

@implementation NSScrollView (extra)

- (void)scrollToTop
{
    [self.contentView scrollToPoint:NSMakePoint(0, 0)];
    [self reflectScrolledClipView:self.contentView];
}

@end
