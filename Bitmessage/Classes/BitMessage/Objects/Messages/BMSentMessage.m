//
//  BMSentMessage.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/19/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMSentMessage.h"
#import "BMProxyMessage.h"

@implementation BMSentMessage

- (NSString *)nodeTitle
{
    return self.toAddressLabel;
}

/*
+ (BMMessage *)withDict:(NSDictionary *)dict
{
    NSLog(@"sent dict %@", dict);
    return [super withDict:dict];
}
*/

- (NSDictionary *)statusDict
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"not found", @"notfound",
            @"queued", @"msgqueued",
            @"broadcast queued", @"broadcastqueued",
            @"broadcast sent", @"broadcastsent",
            @"doing public key proof of work", @"doingpubkeypow",
            @"awaiting public key", @"awaitingpubkey",
            @"doing message proof of work", @"doingmsgpow",
            @"force proof of work", @"forcepow",
            @"sent but unacknowledged", @"msgsent",
            @"sent, no acknowledge expected", @"msgsentnoackexpected",
            @"received", @"ackreceived", nil];
}

- (NSArray *)readStates
{
    return [NSArray arrayWithObjects:@"msgsentnoackexpected", @"ackreceived", @"broadcastsent", nil];
}

- (BOOL)read
{
    return [self.readStates containsObject:[self getStatus]];
}

- (NSString *)getHumanReadbleStatus
{
    NSString *status = self.getStatus;
    status = [self.statusDict objectForKey:status];
    return status;
}

- (NSString *)getStatus
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"getStatus"];
    NSArray *params = [NSArray arrayWithObjects:self.ackData, nil];
    [message setParameters:params];
    //message.debug = YES;
    [message sendSync];
    id result = [message responseValue];
    //NSLog(@"getStatus result %@", result);
    
    /* responses: notfound, msgqueued, broadcastqueued, broadcastsent, doingpubkeypow, awaitingpubkey, doingmsgpow, forcepow, msgsent, msgsentnoackexpected, or ackreceived */
    
    return result;
}

@end
