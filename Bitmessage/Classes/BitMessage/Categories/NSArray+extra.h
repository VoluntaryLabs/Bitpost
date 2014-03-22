//
//  NSArray+extra.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/8/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (extra)

- (NSArray *)reversedArray;
- (NSArray *)sortedStrings;

@end

@interface NSMutableArray (extra)

- (void)reverse;
- (void)mergeWith:(NSArray *)otherArray;


@end
