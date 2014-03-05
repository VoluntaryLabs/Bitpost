//
//  BMTextView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/4/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMTextView.h"

@implementation BMTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)setFontSize:(CGFloat)pointSize
{
    self.font = [NSFont fontWithName:@"Open Sans Light" size:pointSize];
}

- (void)setupForEditing
{
    self.font = [NSFont fontWithName:@"Open Sans Light" size:24.0];
    self.textColor = [NSColor colorWithCalibratedWhite:1.0 alpha:1.0];
    self.editable = YES;
    [self setRichText:NO];
    //[self setDrawsBackground:NO];
    self.backgroundColor = [NSColor clearColor];
    [self setFocusRingType:NSFocusRingTypeNone];
    
    [self setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self setAlignment:NSCenterTextAlignment];
    [self setRichText:NO];
    [self setInsertionPointColor:[NSColor whiteColor]];
    
    [self setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSColor colorWithCalibratedWhite:.3 alpha:1.0], NSBackgroundColorAttributeName,
      [NSColor whiteColor], NSForegroundColorAttributeName,
      nil]];
}


- (void)setupForDisplay
{
    self.font = [NSFont fontWithName:@"Open Sans Light" size:16.0];
    self.textColor = [NSColor colorWithCalibratedWhite:.5 alpha:1.0];
    self.editable = NO;
    [self setAlignment:NSCenterTextAlignment];
    [self setRichText:NO];
    //[self setDrawsBackground:NO];
    self.backgroundColor = [NSColor clearColor];
    
    [self setSelectable:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
}

@end
