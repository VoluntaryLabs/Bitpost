//
//  BMReceivedMessages.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMReceivedMessages.h"
#import "BMReceivedMessage.h"
#import "BMClient.h"
#import "NSArray+extra.h"
#import "BMMessage.h"

@implementation BMReceivedMessages

- (id)init
{
    self = [super init];
    //self.actions = [NSMutableArray arrayWithObjects:@"refresh", nil];
    self.children = [NSMutableArray array];
    return self;
}

- (void)fetch
{
    NSInteger lastUnreadCount = self.unreadCount;
    
    //self.children = [self getAllInboxMessages];
    [self.children mergeWith:[self getAllInboxMessages]];
    [self setChildren:self.children]; // so node parents set
    
    [self sortChildren];
    
    if (!_hasFetchedBefore && (lastUnreadCount != self.unreadCount))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BMReceivedMessagesUnreadCountChanged" object:self];
    }
    
    _hasFetchedBefore = YES;
}

- (void)sortChildren
{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"receivedTime" ascending:NO];
    [self.children sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
}

- (BMClient *)client
{
    return (BMClient *)self.nodeParent;
}

- (NSMutableArray *)filterMessages:(NSMutableArray *)messages
{
    NSMutableArray *results = [NSMutableArray array];

    //BMSubscriptions *subscriptions = self.client.subscriptions;
    //[subscriptions prepareToMessageMerge];
    
    BMChannels *channels = self.client.channels;
    [channels prepareToMergeChildren];
    
    for (BMReceivedMessage *message in messages)
    {
        // remove deleted
        if (![self.client.deletedMessagesDB hasMarked:message.msgid])
        {
            /*if ([subscriptions mergeMessage:message])
            {
                continue;
            }
            else */
            if ([channels mergeChild:message])
            {
                continue;
            }
            else
            {
                [results addObject:message];
            }
        }
    }
    
    //[subscriptions completeMessageMerge];
    [channels completeMergeChildren];
    
    return results;
}

- (NSMutableArray *)getAllInboxMessages
{
    NSMutableArray *messages = [[[BMClient sharedBMClient] messages]
            getMessagesWithMethod:@"getAllInboxMessages"
            andKey:@"inboxMessages"
            class:[BMReceivedMessage class]];
    
    messages = [self filterMessages:messages];
    
    return messages;
}

- (NSString *)nodeTitle
{
    return @"Inbox";
}

- (NSInteger)unreadCount
{
    NSInteger unreadCount = 0;
    
    for (BMMessage *message in self.children)
    {
        if (![message read])
        {
            unreadCount ++;
        }
    }
    
    return unreadCount;
}

- (BOOL)canSearch
{
    return YES;
}

- (void)search:(NSString *)aString
{
    
}

@end
