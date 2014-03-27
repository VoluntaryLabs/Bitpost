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
#import "BMMessage.h"
#import "BMSentMessage.h"

@implementation BMSentMessages

- (id)init
{
    self = [super init];
    //self.actions = [NSMutableArray arrayWithObjects:@"refresh", nil];
    return self;
}

- (void)fetch
{
    //self.children = [self getAllSentMessages];
    //[self.children reverse];
    
    [self.children mergeWith:[self getAllSentMessages]];
    [self setChildren:self.children]; // so node parents set
    [self sortChildren];
    [self updateUnreadCount];
    
    // hack to use unread color

    for (BMMessage *child in self.children)
    {
        [child setRead:YES];
    }
}

- (void)sortChildren
{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"lastActionTime" ascending:NO];
    [self.children sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
}

- (NSMutableArray *)getAllSentMessages
{
    return [[[BMClient sharedBMClient] messages]
            getMessagesWithMethod:@"getAllSentMessages"
            andKey:@"sentMessages"
            class:[BMSentMessage class]];

}

- (NSString *)nodeTitle
{
    return @"Sent";
}

@end
