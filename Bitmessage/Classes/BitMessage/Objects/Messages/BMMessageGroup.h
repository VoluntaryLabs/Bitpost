//
//  BMMessageGroup.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"
#import "BMMessage.h"

@interface BMMessageGroup : BMNode

@property (strong, nonatomic) NSMutableArray *mergingChildren;
@property (assign, nonatomic) NSInteger unreadCount;

- (void)prepareToMergeChildren;
- (BOOL)mergeChild:(BMMessage *)aMessage;
- (void)completeMergeChildren;

// ----------------------

- (void)updateUnreadCount;
- (void)incrementUnreadCount;
- (void)decrementUnreadCount;

// -----------------------

- (void)deleteAll;

@end
