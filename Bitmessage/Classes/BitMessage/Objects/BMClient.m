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
    for (id child in self.children)
    {
        if ([child respondsToSelector:@selector(childWithAddress:)])
        {
            BMAddressed *addr = [child childWithAddress:addressString];
            if (addr && addr.label && ![addr.label isEqualToString:@""])
            {
                return addr.label;
            }
        }
    }
    
    return nil;
}


@end
