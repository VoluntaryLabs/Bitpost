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
    NSRange r = self.selectedRange;
    
    if (r.length)
    {
        [self setSelectedRange:NSMakeRange(r.location, 0)];
    }
    
    if (self.window.firstResponder == self)
    {
        [self.window makeFirstResponder:nil];
    }
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

- (BOOL)didTab
{
    if ([self.string containsString:@"\t"])
    {
        [self removeTabs];
        //[self endEditing];
        return YES;
    }
    
    return NO;
}

- (void)removeTabs
{
    [self setString:[self.string stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
    [self display];
}

- (void)removeReturns
{
    [self setString:[self.string stringWithReturnsRemoved]];
    [self display];
}

@end
