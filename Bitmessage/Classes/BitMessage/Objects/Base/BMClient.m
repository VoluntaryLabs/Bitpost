//
//  BMClient.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMClient.h"
#import "BMAddressed.h"

@implementation BMClient

static BMClient *sharedBMClient;

+ (BMClient *)sharedBMClient
{
    if (!sharedBMClient)
    {
        sharedBMClient = [BMClient alloc];
        sharedBMClient = [sharedBMClient init];
    }
    
    return sharedBMClient;
}


- (id)init
{
    self = [super init];
    
    self.shouldSortChildren = NO;
    
    self.identities    = [[BMIdentities alloc] init];
    self.contacts      = [[BMContacts alloc] init];
    self.messages      = [[BMMessages alloc] init];
    self.subscriptions = [[BMSubscriptions alloc] init];
    self.channels      = [[BMChannels alloc] init];
    
    [self addChild:self.messages.received];
    [self addChild:self.messages.sent];
    [self addChild:self.contacts];
    [self addChild:self.identities];
    [self addChild:self.channels];
    [self addChild:self.subscriptions];

    self.readMessagesDB = [[BMDatabase alloc] init];
    [self.readMessagesDB setName:@"readMessagesDB"];
    
    self.deletedMessagesDB = [[BMDatabase alloc] init];
    [self.deletedMessagesDB setName:@"deletedMessagesDB"];
    
    // market
    
    self.markets = [[MKMarkets alloc] init];
    [self addChild:self.markets];

    // fetch these addresses first so we can filter messages
    // when we fetch them
    
    [self.channels fetch];
    [self.subscriptions fetch];
    
    [self deepFetch];

    return self;
}

- (void)refresh
{
    [self.messages.received refresh];
    [self.messages.sent refresh];
}

- (CGFloat)nodeSuggestedWidth
{
    return 150.0;
}

- (NSString *)labelForAddress:(NSString *)addressString
{
    for (BMAddressed *child in self.allAddressed)
    {
        //NSLog(@"child.label '%@' '%@'", child.label, child.address);
        if ([child.address isEqualToString:addressString])
        {
            return child.label;
        }
    }
    
    return addressString;
}

- (NSString *)addressForLabel:(NSString *)labelString // returns nil if none found
{
    for (BMAddressed *child in self.allAddressed)
    {
        if ([child.label isEqualToString:labelString])
        {
            return child.address;
        }
    }
    
    return nil;
}

- (NSMutableArray *)fromAddressLabels
{
    NSMutableArray *addressLabels = [NSMutableArray array];
    
    for (BMAddressed *child in self.identities.children)
    {
        [addressLabels addObject:child.label];
    }
    
    return addressLabels;
}

- (NSMutableArray *)allAddressed
{
    NSMutableArray *results = [self noneIdentityAddressed];
    [results addObjectsFromArray:self.identities.children];
    return results;
}

- (NSMutableArray *)noneIdentityAddressed
{
    NSMutableArray *results = [NSMutableArray array];
    [results addObjectsFromArray:self.contacts.children];
    [results addObjectsFromArray:self.subscriptions.children];
    [results addObjectsFromArray:self.channels.children];
    return results;
}

- (NSMutableArray *)toAddressLabels
{
    NSMutableArray *addressLabels = [NSMutableArray array];
    
    for (BMAddressed *child in self.noneIdentityAddressed)
    {
        [addressLabels addObject:child.label];
    }
    
    return addressLabels;
}

- (NSMutableArray *)allAddressLabels
{
    NSMutableArray *all = [NSMutableArray array];
    [all addObjectsFromArray:self.fromAddressLabels];
    [all addObjectsFromArray:self.toAddressLabels];
    return all;
}

- (BOOL)hasNoIdentites
{
    return [self.identities.children count] == 0;
}

@end
