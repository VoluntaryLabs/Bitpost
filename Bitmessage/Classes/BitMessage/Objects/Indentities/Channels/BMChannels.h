//
//  BMChannels.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/28/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"
#import "BMChannel.h"

@interface BMChannels : BMNode

- (BMChannel *)channelWithPassphraseJoinIfNeeded:(NSString *)aTitle;

@end
