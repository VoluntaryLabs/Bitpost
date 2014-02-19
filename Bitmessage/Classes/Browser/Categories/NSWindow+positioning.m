//
//  NSWindow+positioning.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/18/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSWindow+positioning.h"

@implementation NSWindow (positioning)

- (void)setCenterPoint:(NSPoint)newCenter
{
    NSRect f = self.frame;
    CGFloat w = f.size.width;
    CGFloat h = f.size.height;
    
    NSRect newFrame = NSMakeRect(newCenter.x - w/2, newCenter.y - h/2, w, h);
    [self setFrame:newFrame display:YES];
}

- (NSPoint)centerPoint
{
    NSRect f = [self frame];
    return NSMakePoint(f.origin.x + f.size.width/2, f.origin.y + f.size.height/2);
}

- (void)centerInFrontOfWindow:(NSWindow *)aWindow
{
    [self setCenterPoint:[aWindow centerPoint]];
}

- (void)centerInMainWindow
{
    [self centerInFrontOfWindow:[[NSApplication sharedApplication] mainWindow]];
}

@end
