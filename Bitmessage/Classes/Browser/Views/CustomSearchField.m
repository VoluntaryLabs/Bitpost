//
//  CustomSearchField.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/19/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "CustomSearchField.h"
#import "NSView+sizing.h"

@implementation CustomSearchField

/*
- (void)awakeFromNib
{
    [self setupCollapsed];
}
*/

- (void)setupCollapsed
{
    [self setBordered:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setEditable:NO];
    [self setSelectable:NO];
}

- (void)setupExpanded
{
    [self setBordered:YES];
    [self setFocusRingType:NSFocusRingTypeExterior];
    [self setEditable:YES];
    [self setSelectable:YES];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupCollapsed];
        [self setDelegate:self];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent
{
    // only get's this if the magnifying glass icon was clicked
    NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSLog(@"mouse position %i, %i", (int)p.x, (int)p.y);
    [super mouseDown:theEvent];
    [self expand];
}

- (void)expand
{
    self.expandAnimation = [[NSAnimation alloc] initWithDuration:10.0
                                     animationCurve:NSAnimationEaseIn];
    [_expandAnimation setFrameRate:20.0];
    [_expandAnimation setAnimationBlockingMode:NSAnimationNonblocking];
    [_expandAnimation setDelegate:self];
    [_expandAnimation startAnimation];
}

- (BOOL)animationShouldStart:(NSAnimation *)animation
{
    NSLog(@"animationShouldStart ");
    return YES;
}

- (void)animationDidStop:(NSAnimation *)animation
{
    NSLog(@"animationDidStop ");
}

- (void)animation:(NSAnimation *)animation didReachProgressMark:(NSAnimationProgress)progress
{
    
    NSLog(@"didReachProgressMark ");
}

//- (float)animation:(NSAnimation *)animation valueForProgress:(NSAnimationProgress)progress
- (float)animation:(NSAnimation *)animation valueForProgress:(NSAnimationProgress)progress
{
    NSLog(@"valueForProgress ");
    CGFloat v = [animation currentValue];
    [self setWidth:v*100];
    [self setNeedsDisplay];
    return v;
}

- (void)collapse
{
    
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    NSLog(@"textShouldBeginEditing");
    return YES;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSLog(@"textShouldEndEditing");
    return YES;
}

@end
