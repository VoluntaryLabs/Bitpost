//
//  NSWindow+positioning.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/18/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (positioning)

- (void)setCenterPoint:(NSPoint)newCenter;
- (NSPoint)centerPoint;
- (void)centerInFrontOfWindow:(NSWindow *)aWindow;
- (void)centerInMainWindow;

@end
