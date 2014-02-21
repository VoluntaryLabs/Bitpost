//
//  BMSubscription.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddressed.h"

@interface BMSubscription : BMAddressed

@property (assign, nonatomic) BOOL enabled;

+ (BMSubscription *)withDict:(NSDictionary *)dict;

- (BOOL)subscribe;
- (void)delete;


@end
