//
//  MarginTextView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/16/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MarginTextView.h"

@implementation MarginTextView

- (void)awakeFromNib
{
    [super setTextContainerInset:NSMakeSize(15.0f, 5.0f)]; // needed?
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super setTextContainerInset:NSMakeSize(15.0f, 5.0f)];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (NSPoint)textContainerOrigin
{
    NSPoint origin = [super textContainerOrigin];
    NSPoint newOrigin = NSMakePoint(origin.x + 5.0f, origin.y);
    return newOrigin;
}

@end
