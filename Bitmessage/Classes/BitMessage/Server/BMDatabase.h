//
//  BMDatabase.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

// database to workaround bitmessage bugs like reappearing deleted messages

#import "JSONDB.h"

@interface BMDatabase : JSONDB

@property (assign, nonatomic) int daysToCache;

- (void)mark:(NSString *)messageId;
- (BOOL)hasMarked:(NSString *)messageId;

- (void)removeOldKeys;

@end
