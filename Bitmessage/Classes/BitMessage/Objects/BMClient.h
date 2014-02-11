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

@interface BMClient : BMNode

@property (strong, nonatomic) BMIdentities *identities;
@property (strong, nonatomic) BMContacts *contacts;
@property (strong, nonatomic) BMMessages *messages;
@property (strong, nonatomic) BMSubscriptions *subscriptions;

+ (BMClient *)sharedBMClient;

@end
