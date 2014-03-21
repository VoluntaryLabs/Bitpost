//
//  MKSells.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSells.h"

@implementation MKSells

- (id)init
{
    self = [super init];
    
    self.actions = [NSMutableArray arrayWithObjects:@"add", nil];
    
    return self;
}

- (NSString *)nodeTitle
{
    return @"Sells";
}


@end
