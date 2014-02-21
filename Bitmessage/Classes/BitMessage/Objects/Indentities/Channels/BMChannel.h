//
//  BMChannel.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/28/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddressed.h"

@interface BMChannel : BMAddressed

@property (retain, nonatomic) NSString *passphrase;

+ (BMChannel *)withDict:(NSDictionary *)dict;

- (void)create;
//- (void)join;
- (void)delete;

@end
