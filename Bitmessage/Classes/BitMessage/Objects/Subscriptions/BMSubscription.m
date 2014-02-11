//
//  BMSubscription.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMSubscription.h"
#import "BMServerProxy.h"
#import "BMClient.h"

@implementation BMSubscription

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"subscribe", @"unsubscribe", nil];
    return self;
}

+ (BMSubscription *)withDict:(NSDictionary *)dict
{
    id instance = [[[self class] alloc] init];
    [instance setDict:dict];
    return instance;
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self.label encodedBase64] forKey:@"label"];
    [dict setObject:self.address forKey:@"address"];
    [dict setObject:self.enabled forKey:@"enabled"];
    return dict;
}

- (void)setDict:(NSDictionary *)dict
{
    self.label   = [[dict objectForKey:@"label"] decodedBase64];
    self.address = [dict objectForKey:@"address"];
    self.enabled = [dict objectForKey:@"enabled"];
}

- (NSString *)description
{
    return [self.dict description];
}

- (NSString *)nodeTitle
{
    return self.label;
}

- (void)fetch
{
    // is this right?
    self.children = [[[BMClient sharedBMClient] messages] getSentMessagesBySender:self.address];
}

// ----------------------

- (id)subscribe
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"addSubscription"];
    NSArray *params = [NSArray arrayWithObjects:self.address,
                       [self.label encodedBase64], nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}

- (id)unsubscribe
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"deleteSubscription"];
    NSArray *params = [NSArray arrayWithObjects:self.address, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}


@end
