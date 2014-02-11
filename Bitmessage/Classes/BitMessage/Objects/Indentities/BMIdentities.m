//
//  BMIdentities.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/29/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMIdentities.h"
#import "BMServerProxy.h"
#import "BMIdentity.h"

@implementation BMIdentities

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"createNewAddress", nil];
    return self;
}

- (void)fetch
{
    self.children = [[BMServerProxy sharedBMServerProxy] listAddresses2];
}


- (id)createNewAddress
{
    //NSString *address =
    [self createRandomAddressWithLabel:@"unlabeled"];
    [self fetch];
    return nil;
}

- (NSString *)createRandomAddressWithLabel:(NSString *)label
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"createRandomAddress"];
    NSArray *params = [NSArray arrayWithObjects:label.encodedBase64, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}

- (BMIdentity *)identityWithAddress:(NSString *)address
{
    for (BMIdentity *child in self.children)
    {
        if ([child.address isEqualToString:address])
        {
            return child;
        }
    }
    
    return nil;
}

@end
