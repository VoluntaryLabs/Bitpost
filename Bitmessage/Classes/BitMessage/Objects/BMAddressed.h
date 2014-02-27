//
//  BMAddressed.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"

@interface BMAddressed : BMNode

@property (retain, nonatomic) NSString *label;
@property (retain, nonatomic) NSString *address; // base64

+ (NSString *)defaultLabel;

+ (id)withDict:(NSDictionary *)dict;
- (void)setDict:(NSDictionary *)dict;
- (NSMutableDictionary *)dict;

- (NSString *)nodeTitle;

- (BOOL)isValidAddress;
- (NSString *)visibleLabel;
- (void)setVisibleLabel:(NSString *)aLabel;
- (BOOL)canLiveUpdate;

// --- actions ---

- (void)message;

@end
