//
//  BMDictView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BitmessageKit.h>
#import "BMDictView.h"
#import "NSView+sizing.h"
#import "KVFieldView.h"

@implementation BMDictView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.autoresizesSubviews = NO;
        // Initialization code here.
    }
    
    return self;
}

- (void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
    [self setup];
}

- (void)setup
{
    [self removeAllSubviews];
    
    NSArray *keys = self.dict.allKeys.sortedStrings;
    
    for (NSString *key in keys)
    {
        KVFieldView *kv = [[KVFieldView alloc] initWithFrame:NSMakeRect(0, 0, 100, 20)];
        kv.key = key;
        [kv setKey:key];
        [kv setValue:key];
        [self addSubview:kv];
        //[kv layout];
    }
    
    [self stackSubviewsBottomToTopWithMargin:10.0];
    
    [self setHeight:self.maxYOfSubviews];
    [self setWidth:self.maxXOfSubviews];
}

- (void)layout
{
    
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    NSColor *bgColor = [NSColor redColor];
    [bgColor set];
    //NSRectFill(dirtyRect);
}


@end
