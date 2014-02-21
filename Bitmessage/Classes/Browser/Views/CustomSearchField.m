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
    //[self setBackgroundColor:[NSColor clearColor]];
    [self setDrawsBackground:NO];
    [self setNeedsDisplay];
}

- (void)setupExpanded
{
    [self setBordered:YES];
    [self setFocusRingType:NSFocusRingTypeExterior];
    [self setEditable:YES];
    [self setSelectable:YES];
    [self setBackgroundColor:[NSColor whiteColor]];
    [self setBezeled:YES];
    [self setBezelStyle:NSTextFieldRoundedBezel];
    [self setDrawsBackground:YES];
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
    }
    else
    {
        [self setupCollapsed];
    }
}

- (void)timer:anObject
{
    CGFloat v = self.animationValue + 1.0/10.0;

    if (v > 1.0)
    {
        v = 1.0;
        self.animationValue = v;
        //self.isExpanded = !self.isExpanded;
        self.timer = nil;
        [self completeSetup];
    }
    else
    {
        self.animationValue = v;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                  target:self
                                                selector:@selector(timer:)
                                                userInfo:nil
                                                 repeats:NO];
    }
    
}

- (void)setAnimationValue:(float)animationValue
{
    _animationValue = animationValue;
  
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
    [self.superview stackSubviewsRightToLeft];
}

- (CGFloat)minWidth
{
    return 20.0;
}

- (CGFloat)maxWidth
{
    return 150.0;
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
