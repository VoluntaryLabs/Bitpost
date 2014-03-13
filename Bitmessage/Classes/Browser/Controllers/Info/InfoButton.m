//
//  InfoButton.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/11/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "InfoButton.h"

@implementation InfoButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setButtonType:NSMomentaryChangeButton];
        [self setBordered:NO];
        [self setFont:[NSFont fontWithName:@"Open Sans Light" size:16.0]];
        [self setAutoresizingMask: NSViewMinXMargin | NSViewMaxYMargin];
        self.textColor = [NSColor whiteColor];
        [self setAlignment:NSCenterTextAlignment];
    }
    
    return self;
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    
}

- (void)mouseExited:(NSEvent *)theEvent
{
    
}

- (void)updateTrackingAreas
{
    
}

@end
