//
//  MKBuys.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKBuys.h"
#import "MKBuy.h"

@implementation MKBuys

- (id)init
{
    self = [super init];
    
    self.db = [[JSONDB alloc] init];
    [self.db setName:@"Buys"];
    
    [self read];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Buys";
}

- (void)read
{
    [self.db read];
    
    NSDictionary *d = self.db.dict;
    
    for (NSString *k in d.allKeys)
    {
        MKBuy *buy = [[MKBuy alloc] init];
        [buy setDict:[d objectForKey:k]];
        [self.children addObject:buy];
    }
    
    [self sortChildren];
}

- (void)write
{
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    for (MKBuy *buy in self.children)
    {
        NSString *k = [buy.dict objectForKey:@"id"];
        [d setObject:buy.dict forKey:k];
    }
    
    self.db.dict = d;
    [self.db write];
}

@end
