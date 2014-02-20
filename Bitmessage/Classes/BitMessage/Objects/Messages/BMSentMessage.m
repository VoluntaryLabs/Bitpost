//
//  BMSentMessage.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/19/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMSentMessage.h"

@implementation BMSentMessage

- (NSString *)nodeTitle
{
    return self.toAddressLabel;
}

@end
