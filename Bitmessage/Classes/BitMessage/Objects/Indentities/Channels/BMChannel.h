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
@property (retain, nonatomic) NSString *label;
@property (retain, nonatomic) NSString *address;

+ (BMChannel *)withDict:(NSDictionary *)dict;

- (void)create;
- (void)join;
- (void)leave;

@end
