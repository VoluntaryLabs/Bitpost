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
    return self;
}

- (void)fetch
{
    NSInteger lastUnreadCount = self.unreadCount;
    BOOL isFirstFetch = self.children == nil;
    
    self.children = [self getAllInboxMessages];
    [self.children reverse];

    if (!isFirstFetch && (lastUnreadCount != self.unreadCount))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BMReceivedMessagesUnreadCountChanged" object:self];
    }
}

- (NSMutableArray *)getAllInboxMessages
{
    NSMutableArray *messages = [[[BMClient sharedBMClient] messages]
            getMessagesWithMethod:@"getAllInboxMessages"
            andKey:@"inboxMessages"
            class:[BMReceivedMessage class]];

    // remove deleted
    
    NSMutableArray *results = [NSMutableArray array];
    for (BMReceivedMessage *message in messages)
    {
        if (![self.client.deletedMessagesDB hasMarked:message.msgid])
        {
            [results addObject:message];
        }
    }
    
    
    return results;
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
