//
//  ResizingScrollView.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/6/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "ResizingScrollView.h"
#import "NSView+sizing.h"

@implementation ResizingScrollView

- (void)viewWillStartLiveResize
{
    
}

- (void)viewDidEndLiveResize
{
    [self.documentView setWidth:self.width];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self.documentView setWidth:self.width];
}

@end
