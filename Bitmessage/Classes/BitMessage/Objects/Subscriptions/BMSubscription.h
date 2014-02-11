//
//  BMSubscription.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"

@interface BMSubscription : BMNode

@property (retain, nonatomic) NSString *label;
@property (retain, nonatomic) NSString *address; // base64
@property (retain, nonatomic) NSEnumerator *enabled;

+ (BMSubscription *)withDict:(NSDictionary *)dict;

- (void)setDict:(NSDictionary *)dict;
- (NSDictionary *)dict;

- (id)subscribe;
- (id)unsubscribe;

@end
