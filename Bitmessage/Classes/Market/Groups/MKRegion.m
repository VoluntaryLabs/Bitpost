//
//  MKRegion.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/24/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKRegion.h"
#import "MKCategory.h"

@implementation MKRegion

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray array];
    //[self setCanPost:NO];
    return self;
}


- (NSString *)dbName
{
    return @"regions.json";
}

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    if (self.children.count == 0)
    {
        //[self addChild:[MKCategory rootInstance]];
        [self setChildren:[MKCategory rootInstance].children];
    }
    
}

@end
