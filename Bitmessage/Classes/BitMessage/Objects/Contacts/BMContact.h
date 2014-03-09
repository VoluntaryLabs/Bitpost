//
//  BMContact.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddressed.h"

@interface BMContact : BMAddressed

+ (BMContact *)withDict:(NSDictionary *)dict;

- (void)delete;
- (void)update;
- (BOOL)insert;

@end
