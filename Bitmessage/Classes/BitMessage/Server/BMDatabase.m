//
//  BMDatabase.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMDatabase.h"

@implementation BMDatabase

- (id)init
{
    self = [super init];
    self.daysToCache = 5;
    return self;
}

- (void)read
{
    [super read];
    [self removeOldKeys];
}

// --- mark ---

- (void)mark:(NSString *)messageId
{
    NSNumber *d = [NSNumber numberWithLong:[[NSDate date] timeIntervalSinceReferenceDate]];
    
    if ([self.dict objectForKey:messageId] == nil)
    {
        [self.dict setObject:d forKey:messageId];
    }
    
    [self write];
}

- (BOOL)hasMarked:(NSString *)messageId
{
    return [self.dict objectForKey:messageId] != nil;
}

- (void)removeOldKeys
{
    for (NSString *key in self.dict.allKeys)
    {
        NSNumber *d = [self.dict objectForKey:key];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[d longLongValue]];
        int secondsInDay = 60 * 60 * 24;
        
        if ([date timeIntervalSinceNow] > secondsInDay * self.daysToCache)
        {
            [self.dict removeObjectForKey:key];
        }
    }
    [self write];
}

@end
