//
//  MKMarkets.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMarkets.h"
#import <BitMessageKit/BitMessageKit.h>

@implementation MKMarkets

- (id)init
{
    self = [super init];
    
    _rootRegion = (MKRegion *)[MKRegion rootInstance];
    [_rootRegion setName:@"Regions"];
    [self.children addObject:self.rootRegion];
    [_rootRegion updateCounts]; // do this after refresh
    //[_rootRegion setShouldInlineChildren:YES];
    //[self setShouldInlineChildren:YES];
    
    /*
    self.rootCategory = (MKCategory *)[MKCategory rootInstance];
    [self.rootCategory setName:@"For Sale"];
    [self.rootCategory setCanPost:NO];
    [self.children addObject:self.rootCategory];
    */
    
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
    return @"BitMarkets";
}

- (CGFloat)nodeSuggestedWidth
{
    return 150;
}


@end
