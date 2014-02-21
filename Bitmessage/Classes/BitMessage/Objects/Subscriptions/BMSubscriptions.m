//
//  BMSubscriptions.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMSubscriptions.h"
#import "BMProxyMessage.h"
#import "BMSubscription.h"

@implementation BMSubscriptions

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"add", @"refresh", nil];
    [self fetch];
    return self;
}

- (void)fetch
{
    self.children = [self listSubscriptions];
}

- (NSMutableArray *)listSubscriptions
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"listSubscriptions"];
    NSArray *params = [NSArray arrayWithObjects:nil];
    [message setParameters:params];
    [message sendSync];
    
    NSMutableArray *subscriptions = [NSMutableArray array];
    
    NSArray *dicts = [[message parsedResponseValue] objectForKey:@"subscriptions"];
    
    //NSLog(@"\n\ndicts = %@", dicts);
    
    for (NSDictionary *dict in dicts)
    {
        BMSubscription *subscription = [BMSubscription withDict:dict];
        [subscriptions addObject:subscription];
    }
    
    //NSLog(@"\n\n subscriptions = %@", subscriptions);
    
    return subscriptions;
}

- (void)add
{
    BMSubscription *sub = [[BMSubscription alloc] init];
    sub.label = @"Enter subscription label";
    sub.address = @"Enter address";
    [self addChild:sub];
    [self postSelfChanged];
    //[self refresh];
}

- (NSString *)nodeTitle
{
    return @"Subscriptions";
}

- (CGFloat)nodeSuggestedWidth
{
    return 330.0;
}

@end
