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
    [self setBackgroundColor:[NSColor clearColor]];
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

/*
- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}
*/

- (void)mouseDown:(NSEvent *)theEvent
{
    // only get's this if the magnifying glass icon was clicked
    //NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    //NSLog(@"mouse position %i, %i", (int)p.x, (int)p.y);
    [super mouseDown:theEvent];
    
    if (self.isExpanded)
    {
        [self collapse];
    }
    else
    {
        [self expand];
    }
}

- (void)expand
{
    self.animationValue = 0.0;
    [self expandTimer:nil];
    [self setupExpanded];
}

- (void)expandTimer:anObject
{
    self.animationValue += 1.0/10.0;

    if (self.animationValue < 1.0)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                  target:self
                                                selector:@selector(expandTimer:)
                                                userInfo:nil
                                                 repeats:NO];
    }
    else
    {
        self.isExpanded = YES;
    }
    
    if (self.animationValue > 1.0)
    {
        self.animationValue = 1.0;
    }
    
    [self setWidth:20.0 + 150.0*self.animationValue];
    //[self setX:self.x - 4];
    [self.superview stackSubviewsRightToLeft];
}

- (void)collapse
{
    self.animationValue = 0.0;
    [self collapseTimer:nil];
    [self setupCollapsed];
}

- (void)collapseTimer:anObject
{
    self.animationValue += 1.0/10.0;
    
    if (self.animationValue < 1.0)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                      target:self
                                                    selector:@selector(collapseTimer:)
                                                    userInfo:nil
                                                     repeats:NO];
    }
    else
    {
        self.isExpanded = NO;
    }
    
    if (self.animationValue > 1.0)
    {
        self.animationValue = 1.0;
    }
    
    [self setWidth:20.0 + 150.0*(1-self.animationValue)];
    [self.superview stackSubviewsRightToLeft];
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
