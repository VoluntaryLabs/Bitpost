//
//  BMDatabase.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

// database to workaround bitmessage bugs like reappearing deleted messages

#import <Foundation/Foundation.h>

@interface BMDatabase : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableDictionary *dict;

- (void)mark:(NSString *)messageId;
- (BOOL)isMarked:(NSString *)messageId;

- (void)removeOldKeys;

@end
