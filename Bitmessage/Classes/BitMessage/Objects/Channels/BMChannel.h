//
//  BMChannel.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/28/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddressed.h"
#import "BMMessage.h"

@interface BMChannel : BMAddressed

@property (retain, nonatomic) NSMutableArray *mergingChildren;
@property (retain, nonatomic) NSString *passphrase;
@property (assign, nonatomic) NSInteger unreadCount;

+ (BMChannel *)withDict:(NSDictionary *)dict;

- (void)setPassphrase:(NSString *)passphrase;
- (NSString *)passphrase;

- (void)create;
//- (void)join;
- (void)delete;

/// merge

- (void)prepareToMergeChildren;
- (BOOL)mergeChild:(BMMessage *)aMessage;
- (void)completeMergeChildren;

@end
