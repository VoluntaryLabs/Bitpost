//
//  MarginTextView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/16/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MarginTextView.h"

@implementation MarginTextView

- (void)setupInset
{
    [super setTextContainerInset:NSMakeSize(40.0f, 40.0f)];

}
- (void)awakeFromNib
{
    [self setupInset];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupInset];
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

/*
- (NSPoint)textContainerOrigin
{
    NSPoint origin = [super textContainerOrigin];
    NSPoint newOrigin = NSMakePoint(origin.x + 30.0f, origin.y + 30.0);
    return newOrigin;
}
*/

@end
