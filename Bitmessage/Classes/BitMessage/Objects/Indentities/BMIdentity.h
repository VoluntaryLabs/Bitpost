//
//  BMIdentity.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/29/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//


#import "BMAddressed.h"

@interface BMIdentity : BMAddressed

@property (assign, nonatomic) NSInteger stream;
@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) BOOL chan;

+ (BMIdentity *)withDict:(NSDictionary *)dict;

@end
