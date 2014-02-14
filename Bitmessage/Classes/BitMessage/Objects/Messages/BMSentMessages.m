//
//  BMSentMessages.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMSentMessages.h"
#import "BMProxyMessage.h"
#import "BMClient.h"
#import "NSArray+extra.h"


@implementation BMSentMessages

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"refresh", nil];
    return self;
}

- (void)fetch
{
    self.children = [self getAllSentMessages];
    [self.children reverse];
}

- (NSMutableArray *)getAllSentMessages
{
    return [[[BMClient sharedBMClient] messages]
            getMessagesWithMethod:@"getAllSentMessages" andKey:@"sentMessages"];
}

- (NSString *)nodeTitle
{
    return @"Sent";
}

- (void)refresh
{
    [self fetch];
    [self postChanged];
}

@end
