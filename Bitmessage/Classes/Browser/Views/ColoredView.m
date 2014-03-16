//
//  ColoredView.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/9/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "ColoredView.h"

@implementation ColoredView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];

    if (self.backgroundColor)
    {
        [self.backgroundColor setFill];
    }
    
    NSRectFill(dirtyRect);
}

@end
