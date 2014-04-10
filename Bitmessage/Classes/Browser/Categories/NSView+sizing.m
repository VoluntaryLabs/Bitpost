//
//  NSView+sizing.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/6/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSView+sizing.h"
#import <objc/runtime.h>

@implementation NSView (sizing)

- (void)setX:(CGFloat)x
{
    NSRect f = self.frame;
    if (f.origin.x != x)
    {
        f.origin.x = x;
        self.frame = f;
        [self setNeedsDisplay:YES];
    }
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    NSRect f = self.frame;
    
    if (f.origin.y != y)
    {
        f.origin.y = y;
        self.frame = f;
        [self setNeedsDisplay:YES];
    }
}

- (CGFloat)y
{
    return self.frame.origin.y;
}


- (void)setWidth:(CGFloat)w
{
    NSRect f = self.frame;
    
    if (f.size.width != w)
    {
        f.size.width = w;
        self.frame = f;
        [self setNeedsDisplay:YES];
    }
}

- (void)setHeight:(CGFloat)h
{
    NSRect f = self.frame;
    
    if (f.size.height != h)
    {
        f.size.height = h;
        self.frame = f;
        [self setNeedsDisplay:YES];
    }
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

- (CGFloat)maxXOfSubviews
{
    CGFloat max = 0;
    
    for (NSView *subview in self.subviews)
    {
        CGFloat v = subview.maxX;
        if (max < v)
        {
            max = v;
        }
    }
    
    return max;
}

- (CGFloat)minXOfSubviews
{
    CGFloat min = 0;
    
    for (NSView *subview in self.subviews)
    {
        CGFloat v = subview.x;
        if (v < min)
        {
            min = v;
        }
    }
    
    return min;
}

- (CGFloat)maxY
{
    return self.y + self.height;
}

- (CGFloat)maxYOfSubviews
{
    CGFloat max = 0;
    
    for (NSView *subview in self.subviews)
    {
        CGFloat v = subview.maxY;
        if (max < v)
        {
            max = v;
        }
    }
    
    return max;
}

- (CGFloat)minYOfSubviews
{
    CGFloat min = 0;
    
    for (NSView *subview in self.subviews)
    {
        CGFloat v = subview.y;
        if (v < min)
        {
            min = v;
        }
    }
    
    return min;
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
    [self stackSubviewsRightToLeftWithMargin:0];
}

- (void)stackSubviewsRightToLeftWithMargin:(CGFloat)margin
{
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

- (void)stackSubviewsLeftToRightWithMargin:(CGFloat)margin
{
    CGFloat x = 0.0;

    for (NSView *view in self.subviews)
    {
        CGFloat w = view.width;
        [view setX:x];
        
        x += w + margin;
    }
}

- (void)stackSubviewsTopToBottom
{
    [self stackSubviewsTopToBottomWithMargin:0];
}

- (void)stackSubviewsTopToBottomWithMargin:(CGFloat)margin
{
    NSView *lastView = nil;
    
    for (NSView *view in self.subviews)
    {
        if (lastView)
        {
            [view setY:lastView.y - view.height - margin];
        }
        else
        {
            [view setY:self.height - view.height];
        }
        
        [view setX:0];
        lastView = view;
    }
}

- (void)stackSubviewsBottomToTopWithMargin:(CGFloat)margin
{
    CGFloat y = 0;
    
    for (NSView *view in self.subviews)
    {
        view.y = y;
        y += view.height + margin;
    }
}


- (CGFloat)sumOfSubviewHeights
{
    CGFloat sum = 0.0;
    
    for (NSView *view in self.subviews)
    {
        sum += view.frame.size.height;
    }
    
    return sum;
}

- (CGFloat)minSubviewY
{
    CGFloat v = 0;
    
    for (NSView *view in self.subviews)
    {
        if (view.y < v)
        {
            v = view.y;
        }
    }
    
    return v;
}

- (CGFloat)maxSubviewY
{
    CGFloat v = self.height;
    
    for (NSView *view in self.subviews)
    {
        if (view.maxY < v)
        {
            v = view.maxY;
        }
    }
    
    return v;
}

- (void)centerSubviewsX
{
    for (NSView *view in self.subviews)
    {
        [view centerXInSuperview];
    }
}

- (void)centerSubviewsY
{
    for (NSView *view in self.subviews)
    {
        [view centerYInSuperview];
    }
}

- (void)centerStackedSubviewsY
{
    if (self.subviews.count == 0)
    {
        return;
    }
    
    CGFloat ymin = self.minSubviewY;
    CGFloat ymax = self.maxSubviewY;
    CGFloat h = ymax - ymin;
    NSView *firstView = self.subviews.firstObject;
    CGFloat offset = (self.height - h/2) - firstView.y;
    
    for (NSView *view in self.subviews)
    {
        [view setY: view.y + offset];
    }
}

- (void)placeYAbove:(NSView *)aView margin:(CGFloat)margin
{
    NSRect f = self.frame;
    f.origin.y = aView.frame.origin.y + aView.frame.size.height + margin;
    self.frame = f;
}

- (void)placeYBelow:(NSView *)aView margin:(CGFloat)margin
{
    NSRect f = self.frame;
    f.origin.y = aView.frame.origin.y - self.frame.size.height - margin;
    self.frame = f;
}

- (void)placeXRightOf:(NSView *)aView margin:(CGFloat)margin
{
    [self setX:aView.x + aView.width + margin];
}


- (void)placeInTopOfSuperviewWithMargin:(CGFloat)margin
{
    [self setY:self.superview.height - self.height - margin];
}

- (void)adjustSubviewsX:(CGFloat)dx
{
    for (NSView *subview in self.subviews)
    {
        [subview setX:subview.x + dx];
    }
}

- (void)adjustSubviewsY:(CGFloat)dy
{
    for (NSView *subview in self.subviews)
    {
        [subview setY:subview.y + dy];
    }
}


/*
- (BOOL)isOpaque
{
    NSNumber *isOpaque = objc_getAssociatedObject(self, @"isOpaque");
    
    if (isOpaque && !isOpaque.boolValue)
    {
        return NO;
    }
 
    return NO;
}

- (void)setIsOpaque:(BOOL)aBool
{
    objc_setAssociatedObject(self, @"isOpaque", [NSNumber numberWithBool:aBool], OBJC_ASSOCIATION_RETAIN);
}
*/

- (void)animateUpFadeIn
{
    CGFloat dy = 15;
    
    NSRect oldFrame = self.frame;
    NSRect startFrame = self.frame;
    startFrame.origin.y -= dy;
    self.frame = startFrame;
    self.alphaValue = 0.0;
    
    //[self setIsOpaque:NO];
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1.0f];
    
    [[self animator] setFrame:oldFrame];
    [[self animator] setAlphaValue:1.0];
    
    [NSAnimationContext endGrouping];
}

- (void)animateDownFadeOut
{
    CGFloat dy = 15;
    
    NSRect oldFrame = self.frame;
    NSRect startFrame = self.frame;
    startFrame.origin.y += dy;
    self.frame = startFrame;
    //self.alphaValue = 0.0;
    
    //[self setIsOpaque:NO];
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1.0f];
    
    [[self animator] setFrame:oldFrame];
    [[self animator] setAlphaValue:0.0];
    
    [NSAnimationContext endGrouping];
}

- (void)animateFadeOut
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1.0f];
    [[self animator] setAlphaValue:0.0];
    [NSAnimationContext endGrouping];
}

- (void)animateFadeIn
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1.0f];
    [[self animator] setAlphaValue:1.0];
    [NSAnimationContext endGrouping];
}

// subviews

- (void)removeAllSubviews
{
    for (NSView *subview in self.subviews.copy)
    {
        [subview removeFromSuperview];
    }
}

- (void)show
{
    NSLog(@"%@ %i, %i %ix%i",
          NSStringFromClass(self.class),
          (int)self.x, (int)self.y,
          (int)self.width, (int)self.height);
}

- (void)sizeAndRepositionSubviewsToFit
{
    [self adjustSubviewsX:-self.minXOfSubviews];
    [self adjustSubviewsY:-self.minYOfSubviews];
    [self setWidth:self.maxXOfSubviews];
    [self setHeight:self.maxYOfSubviews];
}

@end
