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

// extra

#import "BMMessage.h"
#import "BMChannel.h"
#import "BMSubscription.h"
#import "BMContact.h"
#import "BMIdentity.h"
#import "BMAddress.h"

// categories

#import "NSString+BM.h"
#import "BMServerProcess.h"
// market

//#import "MKMarkets.h"


@interface BMClient : BMNode

@property (strong, nonatomic) BMServerProcess *bitmessageProcess;
@property (strong, nonatomic) NSTimer *refreshTimer;
@property (assign, nonatomic) NSTimeInterval refreshInterval;

@property (strong, nonatomic) BMIdentities *identities;
@property (strong, nonatomic) BMContacts *contacts;
@property (strong, nonatomic) BMMessages *messages;
@property (strong, nonatomic) BMSubscriptions *subscriptions;
@property (strong, nonatomic) BMChannels *channels;
@property (strong, nonatomic) BMDatabase *readMessagesDB;
@property (strong, nonatomic) BMDatabase *deletedMessagesDB;

//@property (strong, nonatomic) MKMarkets *markets;


+ (BMClient *)sharedBMClient;

- (void)refresh;
- (NSString *)labelForAddress:(NSString *)addressString; // returns address if none found
- (NSString *)addressForLabel:(NSString *)labelString; // returns address if none found

- (NSMutableArray *)fromAddressLabels;
- (NSMutableArray *)toAddressLabels;
- (NSMutableArray *)allAddressLabels;

- (BOOL)hasNoIdentites;

// --- server --------------------------

//- (void)startServer;
- (void)stopServer; // call when app quits

@end
