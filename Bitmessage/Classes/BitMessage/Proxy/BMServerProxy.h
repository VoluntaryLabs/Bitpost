//
//  BMServerProxy.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMProxyMessage.h"
#import "BMMessage.h"
#import "BMSubscription.h"
#import "BMChannel.h"

@interface BMServerProxy : NSObject

+ (BMServerProxy *)sharedBMServerProxy;

- (void)test;
/*

// getting messages

- (NSMutableArray *)getAllInboxMessages;

- (BMMessage *)getInboxMessageByID:(NSString *)msgId;
- (BMMessage *)getSentMessageByAckData:(NSData *)data;
- (BMMessage *)getSentMessageByID:(NSString *)msgId;
- (BMMessage *)getSentMessagesBySender:(NSString *)sender;

//- (id)sendMessage:(BMMessage *)m;
//- (id)trashMessage:(NSString *)msgId;


// subscriptions

- (NSMutableArray *)listSubscriptions;
- (id)addSubscription:(BMSubscription *)subscription;
- (id)deleteSubscription:(BMSubscription *)subscription;


// channels

- (id)createChan:(BMChannel *)channel;
- (id)joinChan:(BMChannel *)channel;
- (id)leaveChan:(BMChannel *)channel;
*/
// addresses

- (id)deleteAddress:(NSString *)address;

- (NSString *)createRandomAddressWithLabel:(NSString *)label;


// contacts

- (NSMutableArray *)listAddressBookEntries;

// identities

- (NSMutableArray *)listAddresses2;

@end
