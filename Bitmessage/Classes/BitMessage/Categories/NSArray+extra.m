//
//  NSArray+extra.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/8/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSArray+extra.h"

@implementation NSArray (extra)

- (NSArray *)reversedArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

/*
- (NSArray *)objectsNotIn:(NSArray *)otherArray
{
    NSMutableArray *notInOther = [NSMutableArray array];
    
    for (id item in self)
    {
        if (![otherArray containsObject:item])
        {
            [notInOther addObject:item];
        }
    }
    
    return notInOther;
}
*/

@end

@implementation NSMutableArray (extra)

- (void)reverse
{
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

- (void)mergeWith:(NSArray *)otherArray
{
    NSMutableSet *selfSet = [NSMutableSet setWithArray:self];
    NSMutableSet *otherSet = [NSMutableSet setWithArray:otherArray];
    
    [otherSet minusSet:selfSet];
    [selfSet unionSet:otherSet];
    
    [self removeAllObjects];
    [self addObjectsFromArray:[selfSet allObjects]];
}


@end