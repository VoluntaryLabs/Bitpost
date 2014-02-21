//
//  BMChannels.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/28/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMChannels.h"
#import "BMChannel.h"
#import "BMProxyMessage.h"

@implementation BMChannels

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"add", @"refresh", nil];
    return self;
}

- (void)fetch
{
    self.children = [self listAddresses2];
}

- (NSMutableArray *)listAddresses2 // identities
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"listAddresses2"];
    NSArray *params = [NSArray arrayWithObjects:nil];
    [message setParameters:params];
    [message sendSync];
    
    NSMutableArray *items = [NSMutableArray array];
    
    //NSLog(@"[message parsedResponseValue] = %@", [message parsedResponseValue]);
    
    NSArray *dicts = [[message parsedResponseValue] objectForKey:@"addresses"];
    
    //NSLog(@"\n\ndicts = %@", dicts);
    
    for (NSDictionary *dict in dicts)
    {
        BMChannel *child = [BMChannel withDict:dict];
        
        if ([child.label hasPrefix:@"[chan] "])
        {
            [items addObject:child];
        }
    }
    
    return items;
}

- (void)add
{
    BMChannel *channel = [[BMChannel alloc] init];
    [channel setPassphrase:@"Enter channel name"];
    [channel create];
    [self refresh];
}

- (NSString *)nodeTitle
{
    return @"Channels";
}

@end
