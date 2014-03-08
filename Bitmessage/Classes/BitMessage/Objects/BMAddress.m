//
//  BMAddress.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/29/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddress.h"
#import "BMProxyMessage.h"

@implementation BMAddress


+ (BOOL)isValidAddress:(NSString *)address
{
    if (![address hasPrefix:@"BM-"] || !([address length] > 30))
    {
        return NO;
    }
    
    BMAddress *add = [[BMAddress alloc] init];
    add.address = address;
    [add decode];
    return add.isValid;
}

- (void)setDict:(NSDictionary *)dict
{
    self.status = [dict objectForKey:@"status"];
    self.addressVersion = [dict objectForKey:@"addressVersion"];
    self.streamNumber = [dict objectForKey:@"streamNumber"];
    self.ripe = [[dict objectForKey:@"ripe"] decodedBase64];
}

- (void)decode
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"decodeAddress"];
    [message setParameters:[NSArray arrayWithObject:self.address]];
    //message.debug = YES;
    [message sendSync];
    id dict = [message parsedResponseValue];

    //NSLog(@"response %@", dict);

    if (![[dict objectForKey:@"status"] isEqualToString:@"success"])
    {
        self.isValid = NO;
    }
    else
    {
        self.isValid = YES;
        [self setDict:dict];
    }
}


@end
