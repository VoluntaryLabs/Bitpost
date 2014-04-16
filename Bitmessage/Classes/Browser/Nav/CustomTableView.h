//
//  CustomTableView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 4/14/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomTableView : NSTableView

@property (assign, nonatomic) NSView *eventDelegate;

- (BOOL)acceptsFirstResponder;

@end
