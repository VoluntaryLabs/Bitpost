//
//  ColoredView.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/9/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "ColoredView.h"

@implementation ColoredView

- (BOOL)isOpaque
{
    return NO;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor blueColor];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.backgroundColor)
    {
        [self.backgroundColor setFill];
    }
    
    //NSRectFill(self.frame);
    NSRectFill(dirtyRect);
}

@end
