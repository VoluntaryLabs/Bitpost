//
//  BMServerProxy.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMServerProxy.h"
#import "BMMessage.h"
#import "BMSubscription.h"
#import "BMContact.h"
#import "NSString+BM.h"

static BMServerProxy *sharedBMServerProxy = nil;

@implementation BMServerProxy

+ (BMServerProxy *)sharedBMServerProxy
{
    if (!sharedBMServerProxy)
    {
        sharedBMServerProxy = [[BMServerProxy alloc] init];
    }
    
    return sharedBMServerProxy;
}

- (void)test
{
    int result = [self add:1 and:2];
    
    if (result == 3)
    {
        NSLog(@"BMServerProxy test passed");
    }
}

- (int)add:(int)a and:(int)b
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"add"];
    NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithInt:a],[NSNumber numberWithInt:b], nil];
    [message setParameters:params];
    [message sendSync];
    return [[message responseValue] intValue];
}

/*

- (NSMutableArray *)getAllInboxMessages
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"getAllInboxMessages"];
    [message sendSync];
    
    if (message.error)
    {
        return nil;
    }
    
    NSMutableArray *messages = [NSMutableArray array];

    NSArray *dicts = [[message parsedResponseValue] objectForKey:@"inboxMessages"];
    
    //NSLog(@"\n\ndicts = %@", dicts);

    
    for (NSDictionary *dict in dicts)
    {
        BMMessage *message = [BMMessage withDict:dict];
        [messages addObject:message];
        NSLog(@"messageString: %@", [message messageString]);
    }
    
    NSLog(@"\n\n messages = %@", messages);

    return messages;
}

- (id)sendMessage:(NSString *)methodName withArg:(id)arg
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:methodName];
    [message setParameters:[NSArray arrayWithObject:arg]];
    [message sendSync];

    // add code to raise exception on error?
    
    return [message parsedResponseValue];
}



- (BMMessage *)getInboxMessageByID:(NSString *)msgId
{
    NSDictionary *dict = [self sendMessage:@"getInboxMessageByID" withArg:msgId];
    BMMessage *message = [BMMessage withDict:dict];
    return message;
}

- (BMMessage *)getSentMessageByAckData:(NSData *)data
{
    NSDictionary *dict = [self sendMessage:@"getSentMessageByAckData" withArg:data];
    return [BMMessage withDict:dict];
}

- (BMMessage *)getSentMessageByID:(NSString *)msgId
{
    NSDictionary *dict = [self sendMessage:@"getSentMessageByID" withArg:msgId];
    return [BMMessage withDict:dict];
}

- (BMMessage *)getSentMessagesBySender:(NSString *)sender
{
    NSDictionary *dict = [self sendMessage:@"getSentMessagesBySender" withArg:sender];
    return [BMMessage withDict:dict];
}



- (id)sendMessage:(BMMessage *)m
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"sendMessage"];
    
    // subject and message in base64
    NSArray *params = [NSArray arrayWithObjects:m.toAddress, m.fromAddress, m.subject, m.message, nil];
    
    [message setParameters:params];
    [message sendSync];
    
    return [message parsedResponseValue];
}

- (id)sendBroadcast:(BMMessage *)m
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"sendBroadcast"];
    
    // subject and message in base64
    NSArray *params = [NSArray arrayWithObjects:m.fromAddress, m.subject, m.message, nil];
    
    [message setParameters:params];
    [message sendSync];
    
    return [message parsedResponseValue];
}

- (id)trashMessage:(NSString *)msgId
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"trashMessage"];
    NSArray *params = [NSArray arrayWithObjects:msgId, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}

- (NSMutableArray *)listSubscriptions
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"listSubscriptions"];
    NSArray *params = [NSArray arrayWithObjects:nil];
    [message setParameters:params];
    [message sendSync];
    
    NSMutableArray *subscriptions = [NSMutableArray array];
    
    NSArray *dicts = [[message parsedResponseValue] objectForKey:@"subscriptions"];
    
    //NSLog(@"\n\ndicts = %@", dicts);
    
    for (NSDictionary *dict in dicts)
    {
        BMSubscription *subscription = [BMSubscription withDict:dict];
        [subscriptions addObject:subscription];
    }
    
    NSLog(@"\n\n subscriptions = %@", subscriptions);
    
    return subscriptions;
    
}

- (id)addSubscription:(BMSubscription *)subscription
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"addSubscription"];
    NSArray *params = [NSArray arrayWithObjects:subscription.address,
                       [subscription.label encodedBase64], nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}

- (id)deleteSubscription:(BMSubscription *)subscription
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"deleteSubscription"];
    NSArray *params = [NSArray arrayWithObjects:subscription.address, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}
*/

/*

- (id)createChan:(BMChannel *)channel
{
    // createChan	 <passphrase>	 0.4.2	 Creates a new chan. passphrase must be base64 encoded. Outputs the corresponding Bitmessage address.

    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"createChan"];
    NSArray *params = [NSArray arrayWithObjects:channel.passphrase.encodedBase64, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}

- (id)joinChan:(BMChannel *)channel
{
    // joinChan	 <passphrase> <address>	 0.4.2	 Join a chan. passphrase must be base64 encoded. Outputs "success"

    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"joinChan"];
    NSArray *params = [NSArray arrayWithObjects:channel.passphrase.encodedBase64, channel.address, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}

- (id)leaveChan:(BMChannel *)channel
{
    // leaveChan <address>	 0.4.2	 Leave a chan. Outputs "success". Note that at this time, the address is still shown in the UI until a restart.

    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"leaveChan"];
    NSArray *params = [NSArray arrayWithObjects:channel.address, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}
*/

/*
- (id)deleteAddress:(NSString *)address
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"deleteAddress"];
    NSArray *params = [NSArray arrayWithObjects:address, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}
 */

/*
- (NSString *)createRandomAddressWithLabel:(NSString *)label
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"createRandomAddress"];
    NSArray *params = [NSArray arrayWithObjects:label, nil];
    [message setParameters:params];
    [message sendSync];
    return [message parsedResponseValue];
}
*/



/*
- (NSMutableArray *)listAddressBookEntries // contacts
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"listAddressBookEntries"];
    NSArray *params = [NSArray arrayWithObjects:nil];
    [message setParameters:params];
    [message sendSync];
    
    NSMutableArray *contacts = [NSMutableArray array];
    
    //NSLog(@"\n[message parsedResponseValue] = %@", [message parsedResponseValue]);

    NSArray *dicts = [[message parsedResponseValue] objectForKey:@"addresses"];
    
    
    for (NSDictionary *dict in dicts)
    {
        BMContact *contact = [BMContact withDict:dict];
        [contacts addObject:contact];
    }
    
    //NSLog(@"\n\n contacts = %@", contacts);
    
    return contacts;
}
*/

/*
- (NSMutableArray *)listAddresses2 // identities
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"listAddresses2"];
    NSArray *params = [NSArray arrayWithObjects:nil];
    [message setParameters:params];
    [message sendSync];
    
    NSMutableArray *contacts = [NSMutableArray array];
    
    //NSLog(@"[message parsedResponseValue] = %@", [message parsedResponseValue]);
    
    NSArray *dicts = [[message parsedResponseValue] objectForKey:@"addresses"];
    
    //NSLog(@"\n\ndicts = %@", dicts);
    
    for (NSDictionary *dict in dicts)
    {
        BMContact *contact = [BMContact withDict:dict];
        [contacts addObject:contact];
    }
    
    //NSLog(@"\n\n contacts = %@", contacts);
    
    return contacts;
}
 */

@end
