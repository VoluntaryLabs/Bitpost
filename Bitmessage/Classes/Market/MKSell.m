//
//  MKSell.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSell.h"
#import "NSDate+extra.h"

@implementation MKSell

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"delete", nil];
    self.date = [NSDate date];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Sell";
}

- (NSString *)nodeSubtitle
{
    return @"Draft";
}

- (NSString *)nodeNote
{
    return self.date.itemDateString;
}

- (void)delete
{
    [self.nodeParent removeChild:self];
}

- (NSArray *)properties
{
    NSMutableArray *p = [NSMutableArray array];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"category" forKey:@"name"];
    [dict setObject:@"category" forKey:@"choices"];
    [p addObject:dict];
    
    
    return p;
}


@end
