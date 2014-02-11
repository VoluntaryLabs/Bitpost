//
//  BMIdentity.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/29/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMIdentity.h"
#import "BMServerProxy.h"

@implementation BMIdentity

+ (BMIdentity *)withDict:(NSDictionary *)dict
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

// ----------


@end
