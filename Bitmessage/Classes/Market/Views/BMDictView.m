//
//  BMDictView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMDictView.h"
#import "NSView+sizing.h"
#import "NSArray+extra.h"
#import "KVFieldView.h"

@implementation BMDictView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
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
        [self addSubview:kv];
    }
    
    [self stackSubviewsBottomToTopWithMargin:10.0];
    
    [self setHeight:self.maxYOfSubviews];
    [self setWidth:self.maxXOfSubviews];
}

@end
