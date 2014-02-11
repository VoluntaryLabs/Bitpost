//
//  BMChannel.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/28/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"

@interface BMChannel : BMNode

@property (retain, nonatomic) NSString *passphrase;
@property (retain, nonatomic) NSString *address;

//- (id)create;
- (id)join;
- (id)leave;

@end
