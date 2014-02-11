//
//  BMContact.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"

@interface BMContact : BMNode

@property (retain, nonatomic) NSString *label;
@property (retain, nonatomic) NSString *address; // base64

+ (BMContact *)withDict:(NSDictionary *)dict;

@end
