//
//  NSTextView+extra.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSTextView+extra.h"
#import "NSString+BM.h"


@implementation NSTextView (extra)

- (void)endEditing
{
    //[self resignFirstResponder];
    [self setSelectedRange:NSMakeRange(0, 0)];
    [self.window makeFirstResponder:nil];
}

- (BOOL)endEditingOnReturn
{
    if ([self.string containsString:@"\n"])
    {
        [self removeReturns];
        [self endEditing];
        return YES;
    }
    return NO;
}

- (void)removeReturns
{
    [self setString:[self.string stringWithReturnsRemoved]];
}

@end