//
//  InfoButton.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/11/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "InfoButton.h"
#import <NavKit/NavKit.h>

@implementation InfoButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {

    }
    
    return self;
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    //NSLog(@"mouseEntered");
    if (self.altTitle)
    {
        self.title = self.altTitle;
        NSString *path = [self.titleThemePath stringByAppendingString:@".alt"];
        [self setThemePath:path];
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    //NSLog(@"mouseExited");
    if (self.normalTitle)
    {
        self.title = self.normalTitle;
        [self setThemePath:self.titleThemePath];
    }
}

- (void)updateTrackingAreas
{
    //NSLog(@"updateTrackingAreas");
    
    [self removeTrackingArea:_trackingArea];
    
    NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited|NSTrackingActiveInActiveApp;
    _trackingArea  = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
    
    [self addTrackingArea:_trackingArea];
    
    [super updateTrackingAreas];
}

@end
