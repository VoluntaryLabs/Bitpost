//
//  BMChannel.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/28/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMChannel.h"
#import "BMProxyMessage.h"

@implementation BMChannel

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"join", @"delete", nil];
    return self;
}

// -----------------------------

+ (BMChannel *)withDict:(NSDictionary *)dict
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

// -----------------------------

- (void)setPassphrase:(NSString *)passphrase
{
    self.label = [NSString stringWithFormat:@"[chan] %@", passphrase];
}

- (NSString *)passphrase
{
    NSString *prefix = @"[chan] ";
    
    if ([self.label hasPrefix:prefix])
    {
        return [self.label stringByReplacingOccurrencesOfString:prefix withString:@""];
    }
    
    return @"";
}

- (void)create
{
    // createChan	 <passphrase>	 0.4.2	 Creates a new chan. passphrase must be base64 encoded. Outputs the corresponding Bitmessage address.
    
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"createChan"];
    NSArray *params = [NSArray arrayWithObjects:self.passphrase.encodedBase64, nil];
    [message setParameters:params];
    message.debug = YES;
    [message sendSync];
    self.address = [message responseValue];
    NSLog(@"self.address %@", self.address);
    [self postParentChanged];
}

- (void)join
{
    // joinChan	 <passphrase> <address>	 0.4.2	 Join a chan. passphrase must be base64 encoded. Outputs "success"
    
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"joinChan"];
    NSArray *params = [NSArray arrayWithObjects:self.passphrase.encodedBase64, self.address, nil];
    [message setParameters:params];
    message.debug = YES;
    [message sendSync];
    id response = [message parsedResponseValue];
    NSLog(@"response %@", response);
    [self postParentChanged];
}

- (void)delete
{
    [self leave];
}

- (void)leave
{
    // leaveChan <address>	 0.4.2	 Leave a chan. Outputs "success". Note that at this time, the address is still shown in the UI until a restart.
    
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"leaveChan"];
    NSArray *params = [NSArray arrayWithObjects:self.address, nil];
    [message setParameters:params];
    message.debug = YES;
    [message sendSync];
    id response = [message parsedResponseValue];
    NSLog(@"response %@", response);

    [self.nodeParent removeChild:self];
    [self postParentChanged];
}

- (NSString *)nodeTitle
{
    return self.passphrase;
}


@end
