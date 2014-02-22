//
//  BMSubscription.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMSubscription.h"
#import "BMProxyMessage.h"
#import "BMClient.h"
#import "BMAddress.h"

@implementation BMSubscription

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"message", @"delete", nil];
    return self;
}

+ (BMSubscription *)withDict:(NSDictionary *)dict
{
    id instance = [[[self class] alloc] init];
    [instance setDict:dict];
    return instance;
}

- (NSMutableDictionary *)dict
{
    NSMutableDictionary *dict = [super dict];
    [dict setObject:[NSNumber numberWithBool:self.enabled] forKey:@"enabled"];
    return dict;
}

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    self.enabled = [[dict objectForKey:@"enabled"] boolValue];
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

- (BOOL)subscribe
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"addSubscription"];
    NSArray *params = [NSArray arrayWithObjects:self.address,
                       [self.label encodedBase64], nil];
    [message setParameters:params];
    message.debug = NO;
    [message sendSync];
    id response = [message parsedResponseValue];
    NSLog(@"response %@", response);
    return YES;
}

- (void)delete
{
    [self unsubscribe];
}

- (void)unsubscribe
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"deleteSubscription"];
    NSArray *params = [NSArray arrayWithObjects:self.address, nil];
    [message setParameters:params];
    message.debug = NO;
    [message sendSync];
    id response = [message parsedResponseValue];
    NSLog(@"response %@", response);
}

- (void)update
{
    NSLog(@"updating subscription '%@' '%@'", self.address, self.label);
    
    [self delete];
    
    if ([self subscribe])
    {
        [self postParentChanged];
    }
}

- (NSString *)visibleLabel
{
    return self.label;
}

- (void)setVisibleLabel:(NSString *)aLabel
{
    self.label = aLabel;
}

- (BOOL)canLiveUpdate
{
    return NO;
}

@end
