//
//  BMIdentity.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/29/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//


#import "BMNode.h"

@interface BMIdentity : BMNode

@property (retain, nonatomic) NSString *label;
@property (retain, nonatomic) NSString *address;
@property (assign, nonatomic) NSInteger stream;
@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) BOOL chan;

+ (BMIdentity *)withDict:(NSDictionary *)dict;

@end
