//
//  BMSentMessages.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMSentMessages.h"
#import "BMServerProxy.h"
#import "BMClient.h"


@implementation BMSentMessages

- (id)init
{
    self = [super init];
    return self;
}

- (void)fetch
{
    self.children = [self getAllSentMessages];
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

@end
