//
//  BMMessages.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMMessages.h"
#import "BMMessage.h"
#import "BMProxyMessage.h"
#import "BMReceivedMessage.h"


@implementation BMMessages

- (id)init
{
    self = [super init];
    
    self.sent = [[BMSentMessages alloc] init];
    self.received = [[BMReceivedMessages alloc] init];
    
    [self.children addObject:self.sent];
    [self.children addObject:self.received];
    return self;
}


- (NSMutableArray *)getMessagesWithMethod:(NSString *)methodName
                                   andKey:(NSString *)keyName
                                    class:(Class)aClass
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:methodName];
    [message sendSync];
    
    if (message.error)
    {
        return nil;
    }
    
    NSMutableArray *messages = [NSMutableArray array];
    
    NSDictionary *responseDict = [message parsedResponseValue];
    
    //NSLog(@"\n\n responseDict = %@", responseDict);
    
    NSArray *dicts = [responseDict objectForKey:keyName];
    
    //NSLog(@"\n\ndicts = %@", dicts);
    
    
    for (NSDictionary *dict in dicts)
    {
        BMMessage *message = [aClass withDict:dict];
        [messages addObject:message];
        //NSLog(@"messageString: %@", [message messageString]);
    }
    
    //NSLog(@"\n\n messages = %@", messages);
    
    return messages;
}


- (id)getMessage:(NSString *)methodName withArg:(id)arg
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
    NSDictionary *dict = [self getMessage:@"getInboxMessageByID" withArg:msgId];
    BMMessage *message = [BMMessage withDict:dict];
    return message;
}

- (BMMessage *)getSentMessageByAckData:(NSData *)data
{
    NSDictionary *dict = [self getMessage:@"getSentMessageByAckData" withArg:data];
    return [BMMessage withDict:dict];
}

- (BMMessage *)getSentMessageByID:(NSString *)msgId
{
    NSDictionary *dict = [self getMessage:@"getSentMessageByID" withArg:msgId];
    return [BMMessage withDict:dict];
}

- (NSMutableArray *)getSentMessagesBySender:(NSString *)sender
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"getSentMessagesBySender"];
    [message setParameters:[NSArray arrayWithObject:sender]];
    [message sendSync];
    
    if (message.error)
    {
        return nil;
    }
    
    NSMutableArray *messages = [NSMutableArray array];
    NSDictionary *responseDict = [message parsedResponseValue];
    
    //NSLog(@"\n\n getSentMessagesBySender = %@", responseDict);
    
    NSArray *dicts = [responseDict objectForKey:@"sentMessages"];
        
    
    for (NSDictionary *dict in dicts)
    {
        BMMessage *message = [BMMessage withDict:dict];
        [messages addObject:message];
        //NSLog(@"messageString: %@", [message messageString]);
    }
    
    //NSLog(@"\n\n messages = %@", messages);
    
    return messages;
}

- (NSMutableArray *)inboxMessagesFromAddress:(NSString *)anAddress
{
    NSArray *messages = [[self received] children];
    NSMutableArray *filtered = [NSMutableArray array];
    
    for (BMReceivedMessage *message in messages)
    {
        if ([[message fromAddress] isEqualToString:anAddress])
        {
            [filtered addObject:message];
        }
    }
    
    return filtered;
}

- (NSMutableArray *)sentMessagesFromAddress:(NSString *)anAddress
{
    NSArray *messages = [[self sent] children];
    NSMutableArray *filtered = [NSMutableArray array];
    
    for (BMReceivedMessage *message in messages)
    {
        if ([[message fromAddress] isEqualToString:anAddress])
        {
            [filtered addObject:message];
        }
    }
    
    return filtered;
}

@end
