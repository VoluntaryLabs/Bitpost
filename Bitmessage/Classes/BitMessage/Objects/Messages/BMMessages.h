//
//  BMMessages.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"
#import "BMSentMessages.h"
#import "BMReceivedMessages.h"

@interface BMMessages : BMNode

@property (strong, nonatomic) BMSentMessages *sent;
@property (strong, nonatomic) BMReceivedMessages *received;

- (NSMutableArray *)getSentMessagesBySender:(NSString *)sender;
- (NSMutableArray *)getMessagesWithMethod:(NSString *)methodName andKey:(NSString *)keyName class:(Class)aClass;

- (NSMutableArray *)inboxMessagesFromAddress:(NSString *)anAddress;
- (NSMutableArray *)sentMessagesFromAddress:(NSString *)anAddress;

@end
