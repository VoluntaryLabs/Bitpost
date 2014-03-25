//
//  MKCategory.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKCategory.h"


@implementation MKCategory

- (NSString *)dbName
{
    return @"categories.json";
}

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    if (self.children.count == 0)
    {
        [self setCanPost:YES];
    }
    
}

@end
