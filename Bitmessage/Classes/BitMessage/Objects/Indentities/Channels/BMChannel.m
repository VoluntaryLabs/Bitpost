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
    self.actions = [NSMutableArray arrayWithObjects:@"create", @"join", @"leave", nil];
    return self;
}

- (id)create
{
    // createChan	 <passphrase>	 0.4.2	 Creates a new chan. passphrase must be base64 encoded. Outputs the corresponding Bitmessage address.
    
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"createChan"];
    NSArray *params = [NSArray arrayWithObjects:self.passphrase.encodedBase64, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}

- (id)join
{
    // joinChan	 <passphrase> <address>	 0.4.2	 Join a chan. passphrase must be base64 encoded. Outputs "success"
    
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"joinChan"];
    NSArray *params = [NSArray arrayWithObjects:self.passphrase.encodedBase64, self.address, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}

- (id)leave
{
    // leaveChan <address>	 0.4.2	 Leave a chan. Outputs "success". Note that at this time, the address is still shown in the UI until a restart.
    
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"leaveChan"];
    NSArray *params = [NSArray arrayWithObjects:self.address, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}

@end
