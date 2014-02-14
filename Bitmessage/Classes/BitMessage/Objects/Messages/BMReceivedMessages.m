//
//  BMReceivedMessages.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMReceivedMessages.h"
#import "BMClient.h"
#import "NSArray+extra.h"
#import "BMMessage.h"

@implementation BMReceivedMessages

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"refresh", nil];
    return self;
}

- (void)fetch
{
    self.children = [self getAllInboxMessages];
    [self.children reverse];
}

- (NSMutableArray *)getAllInboxMessages
{
    return [[[BMClient sharedBMClient] messages]
            getMessagesWithMethod:@"getAllInboxMessages" andKey:@"inboxMessages"];
}

- (NSString *)nodeTitle
{
    return @"Inbox";
}

- (void)refresh
{
    [self fetch];
    [self postChanged];
}

@end
