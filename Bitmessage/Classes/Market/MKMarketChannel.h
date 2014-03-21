//
//  MKMarketChannel.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"
#import "BMChannel.h"

@interface MKMarketChannel : BMNode

@property (strong, nonatomic) NSString *passphrase;
@property (strong, nonatomic) BMChannel *channel;

- (void)fetch;

@end
