//
//  MKMarkets.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMarkets.h"
#import "JSONDB.h"

@implementation MKMarkets

- (id)init
{
    self = [super init];
    
    self.rootCategory = [[MKCategory alloc] init];
    [self.rootCategory setName:@"For Sale"];
    [self.rootCategory read];
    [self.rootCategory setCanPost:NO];
    [self.children addObject:self.rootCategory];
    
    self.channel = [[MKMarketChannel alloc] init];
    [self.children addObject:self.channel];

    self.wallet  = [[MKWallet alloc] init];
    [self.children addObject:self.wallet];
    
    self.buys  = [[MKBuys alloc] init];
    [self.children addObject:self.buys];

    self.sells = [[MKSells alloc] init];
    [self.children addObject:self.sells];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Markets";
}

- (CGFloat)nodeSuggestedWidth
{
    return 200;
}


@end
