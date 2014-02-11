//
//  BMAddress.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/29/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddress.h"
#import "BMServerProxy.h"

@implementation BMAddress

- (void)createRandomAddress
{
    self.address = [[BMServerProxy sharedBMServerProxy]
                    createRandomAddressWithLabel:self.label];
}

@end
