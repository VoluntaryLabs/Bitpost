//
//  BMMessageGroup.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMMessageGroup.h"
#import "NSArray+extra.h"

@implementation BMMessageGroup

- (void)prepareToMergeChildren
{
    self.mergingChildren = [NSMutableArray array];
}

- (BOOL)mergeChild:(BMMessage *)aMessage
{
    return NO;
}

- (void)completeMergeChildren
{
    [self.children mergeWith:self.mergingChildren];
    [self setChildren:self.children]; // so node parents set
}

@end
