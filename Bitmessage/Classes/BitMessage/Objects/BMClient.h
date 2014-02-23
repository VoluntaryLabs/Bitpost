//
//  BMClient.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"
#import "BMIdentities.h"
#import "BMContacts.h"
#import "BMMessages.h"
#import "BMSubscriptions.h"
#import "BMChannels.h"
#import "BMDatabase.h"

@interface BMClient : BMNode

@property (strong, nonatomic) BMIdentities *identities;
@property (strong, nonatomic) BMContacts *contacts;
@property (strong, nonatomic) BMMessages *messages;
@property (strong, nonatomic) BMSubscriptions *subscriptions;
@property (strong, nonatomic) BMChannels *channels;
@property (strong, nonatomic) BMDatabase *readMessagesDB;
@property (strong, nonatomic) BMDatabase *deletedMessagesDB;


+ (BMClient *)sharedBMClient;

- (void)refresh;
- (NSString *)labelForAddress:(NSString *)addressString;

@end
