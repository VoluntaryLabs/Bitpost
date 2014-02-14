//
//  BMMessage.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"

@interface BMMessage : BMNode

@property (retain, nonatomic) NSNumber *encodingType;
@property (retain, nonatomic) NSString *toAddress;
@property (retain, nonatomic) NSString *msgid;
@property (retain, nonatomic) NSString *message;
@property (retain, nonatomic) NSString *fromAddress;
@property (retain, nonatomic) NSNumber *receivedTime; // RECEIVED
@property (retain, nonatomic) NSNumber *lastActionTime; // SENT
@property (retain, nonatomic) NSString *subject;
@property (assign) BOOL read;

+ (BMMessage *)withDict:(NSDictionary *)dict;

- (void)setDict:(NSDictionary *)dict;
- (NSDictionary *)dict;

- (NSString *)subjectString;
- (NSString *)messageString;
- (NSString *)fromAddressLabel;

- (NSDate *)date;

- (void)send;
- (void)broadcast;
- (void)delete;

- (void)markAsRead;
- (void)markAsUnread;

@end
