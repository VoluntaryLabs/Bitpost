//
//  MKMarketChannel.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMarketChannel.h"
#import <BitMessageKit/BitMessageKit.h>
#import "MKMessage.h"

@implementation MKMarketChannel

- (NSString *)nodeTitle
{
    return @"Channel";
}

- (id)init
{
    self = [super init];
    self.passphrase = @"bitmarkets";
    return self;
}

- (void)fetch
{
    if (!self.channel)
    {
        self.channel = [BMClient.sharedBMClient.channels channelWithPassphraseJoinIfNeeded:self.passphrase];
    }

    // just make sure this is in the fetch chain from BMClient?
    //[[[BMClient sharedBMClient] channels] fetch];

    NSMutableArray *children = [NSMutableArray array];
    NSArray *messages = self.channel.children;
    
    for (BMReceivedMessage *bmMessage in messages)
    {
        MKMessage *mkMessage = [MKMessage withBMMessage:bmMessage];
        
        if (mkMessage)
        {
            [children addObject:mkMessage];
        }
    }
    
    [self setChildren:children];
}

@end
