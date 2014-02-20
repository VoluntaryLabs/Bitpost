//
//  BMClient.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMClient.h"


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
    
    [self.children addObject:self.messages.received];
    [self.children addObject:self.messages.sent];
    [self.children addObject:self.contacts];
    [self.children addObject:self.identities];
    //[self.children addObject:self.subscriptions];
    
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
    BMContact *contact = [[self contacts] contactWithAddress:addressString];
    if (contact && contact.label && ![contact.label isEqualToString:@""])
    {
        return contact.label;
    }
    
    BMIdentity *identity = [[self identities] identityWithAddress:addressString];
    if (identity && identity.label && ![identity.label isEqualToString:@""])
    {
        return identity.label;
    }
    
    return nil;
}


@end
