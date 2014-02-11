//
//  BMSubscriptions.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMSubscriptions.h"
#import "BMServerProxy.h"

@implementation BMSubscriptions

- (id)init
{
    self = [super init];
    [self fetch];
    return self;
}

- (void)fetch
{
    //self.children = [[BMServerProxy sharedBMServerProxy] listSubscriptions];
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

@end
