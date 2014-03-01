//
//  BMIdentities.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/29/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//


#import "BMNode.h"
#import "BMIdentity.h"

@interface BMIdentities : BMNode

- (BMIdentity *)createFirstIdentity;

- (void)add;

- (BMIdentity *)firstIdentity;

@end
