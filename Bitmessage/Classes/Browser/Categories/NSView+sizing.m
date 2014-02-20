//
//  NSView+sizing.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/6/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSView+sizing.h"

@implementation NSView (sizing)

- (void)setX:(CGFloat)x
{
    NSRect f = self.frame;
    f.origin.x = x;
    self.frame = f;
    [self setNeedsDisplay:YES];
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    NSRect f = self.frame;
    f.origin.y = y;
    self.frame = f;
    [self setNeedsDisplay:YES];
}

- (CGFloat)y
{
    return self.frame.origin.y;
}


- (void)setWidth:(CGFloat)w
{
    NSRect f = self.frame;
    f.size.width = w;
    self.frame = f;
    [self setNeedsDisplay:YES];
}

- (void)setHeight:(CGFloat)h
{
    NSRect f = self.frame;
    f.size.height = h;
    self.frame = f;
    [self setNeedsDisplay:YES];
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)maxX
{
    return self.x + self.width;
}

- (CGFloat)maxY
{
    return self.y + self.height;
}


- (void)centerXInSuperview
{
    CGFloat w = [self superview].width;
    [self setX:w/2 - self.width/2];
}

- (void)centerYInSuperview
{
    CGFloat h = [self superview].height;
    [self setY:h/2 - self.height/2];
}

- (void)stackSubviewsRightToLeft
{
    CGFloat margin = 10.0;
    
    NSView *lastView = nil;
    
    for (NSView *view in self.subviews)
    {
        if (lastView)
        {
            [view setX:lastView.x - view.width - margin];
        }
        else
        {
            [view setX:self.width - view.width];
        }
        [view setY:0];
        lastView = view;
    }
}

@end
