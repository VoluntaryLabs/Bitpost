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
    
    //self.channel = [[MKMarketChannel alloc] init];
    self.wallet  = [[MKWallet alloc] init];
    
    self.buys  = [[MKBuys alloc] init];
    self.sells = [[MKSells alloc] init];
    
    //[self.children addObject:self.channel];
    [self.children addObject:self.wallet];
    [self.children addObject:self.buys];
    [self.children addObject:self.sells];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Markets";
}


@end
