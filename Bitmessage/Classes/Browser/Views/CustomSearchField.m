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

- (void)setupCollapsed
{
    [self setBordered:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setEditable:NO];
    [self setSelectable:NO];
    [self setDrawsBackground:NO];
    [self setWidth:self.minWidth];
    [self setNeedsDisplay];
}

- (void)setupExpanded
{
    [self setBordered:YES];
    [self setFocusRingType:NSFocusRingTypeExterior];
    [self setEditable:YES];
    [self setSelectable:YES];
    [self setBackgroundColor:[NSColor colorWithCalibratedWhite:.5 alpha:1.0]];
    [self setBezeled:YES];
    [self setBezelStyle:NSTextFieldRoundedBezel];
    [self setDrawsBackground:YES];
    [self setWidth:self.maxWidth];
    [self setNeedsDisplay];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //if (!self.isExpanded)
        {
            [self setupCollapsed];
        }
        /*
        else
        {
            [self setupExpanded];
        }
        */
        
        [self setDelegate:self];
    }
    
    return self;
}

- (void)connectCancelButton
{
    [[[self cell] cancelButtonCell] setAction:@selector(clearSearchField:)];
    [[[self cell] cancelButtonCell] setTarget:self];
}

- (void)clearSearchField:sender
{
    //[self selectAll:self];
    //[self deleteToEndOfLine:self];
    [self setStringValue:@""];
    [self toggle];
}

- (void)mouseDown:(NSEvent *)event
{
    // only get's this if the magnifying glass icon was clicked
    NSPoint p = [self convertPoint:[event locationInWindow] fromView:nil];
    NSLog(@"mouse position %i, %i", (int)p.x, (int)p.y);
    [super mouseDown:event];

    if ((p.x < 20) && ([event type] == NSLeftMouseDown))
    //if ([event type] == NSLeftMouseDown)
    {
        [self toggle];
    }
}

- (void)toggle
{
    self.isExpanded = !self.isExpanded;
    
    _animationValue = 0.0;
    [self setup];
    
    [self setAnimationValue:1.0]; // skip animation
    [self timer:nil];
}

- (void)setup
{
    if (self.isExpanded)
    {
        [self setupExpanded];
    }
    else
    {
        //[self setupCollapsed];
    }
}

- (void)completeSetup
{
    if (self.isExpanded)
    {
        //[self setupExpanded];
        [self.window makeFirstResponder:self];
    }
    else
    {
        [self setupCollapsed];
    }
}

- (void)timer:anObject
{
    CGFloat timerPeriod = 1.0;
    NSInteger totalFrames = 1.0;
    CGFloat v = self.animationValue + timerPeriod/totalFrames;

    if (v >= 1.0)
    {
        v = 1.0;
        [self setAnimationValue:v];
        [self.timer invalidate];
        self.timer = nil;
        [self completeSetup];
    }
    else if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0 //timerPeriod/60.0
                                                  target:self
                                                selector:@selector(timer:)
                                                userInfo:nil
                                                 repeats:YES];
    }
    else
    {
        self.animationValue = v;
    }
    
}

- (void)setAnimationValue:(float)animationValue
{
    _animationValue = animationValue;
    
    //NSLog(@"animationValue %f", (float) animationValue);
  
    CGFloat v = 0.0;
    
    if (!self.isExpanded)
    {
        v = 1.0 - self.animationValue;
    }
    else
    {
        v = self.animationValue;
    }
    
    [self setWidth:self.minWidth + (self.maxWidth - self.minWidth)*v];
    [self.superview stackSubviewsRightToLeftWithMargin:10.0]; // hack
    [self.superview adjustSubviewsX:-10]; // hack
    [self setNeedsDisplay:YES];
}

- (CGFloat)minWidth
{
    return 30.0;
}

- (CGFloat)maxWidth
{
    return 150.0;
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    //NSLog(@"textShouldBeginEditing");
    return YES;
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    //NSLog(@"controlTextDidChange '%@'", self.stringValue);
    
    if (_searchDelegate)
    {
        [_searchDelegate searchForString:self.stringValue];
    }
    
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    //NSLog(@"textShouldEndEditing");
    return YES;
}

@end
