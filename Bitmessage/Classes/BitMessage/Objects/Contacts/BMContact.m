//
//  BMContact.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMContact.h"
#import "BMProxyMessage.h"

@implementation BMContact

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"delete", nil];
    return self;
}



+ (BMContact *)withDict:(NSDictionary *)dict
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
    return dict;
}

- (void)setDict:(NSDictionary *)dict
{
    self.label   = [[dict objectForKey:@"label"] decodedBase64];
    self.address = [dict objectForKey:@"address"];
}

- (NSString *)nodeTitle
{
    return self.label;
}

/*
- (NSString *)nodeSubtitle
{
    return self.address;
}
 */

// -----

- (id)delete
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"deleteAddress"];
    NSArray *params = [NSArray arrayWithObjects:self.address, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}


@end
