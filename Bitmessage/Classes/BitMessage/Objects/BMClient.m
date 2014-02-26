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
    
    self.identities    = [[BMIdentities alloc] init];
    self.contacts      = [[BMContacts alloc] init];
    self.messages      = [[BMMessages alloc] init];
    self.subscriptions = [[BMSubscriptions alloc] init];
    self.channels      = [[BMChannels alloc] init];
    
    [self.children addObject:self.messages.received];
    [self.children addObject:self.messages.sent];
    [self.children addObject:self.contacts];
    [self.children addObject:self.identities];
    [self.children addObject:self.channels];
    [self.children addObject:self.subscriptions];

    self.readMessagesDB = [[BMDatabase alloc] init];
    [self.readMessagesDB setName:@"readMessagesDB"];
    
    self.deletedMessagesDB = [[BMDatabase alloc] init];
    [self.deletedMessagesDB setName:@"deletedMessagesDB"];
    
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

@end
