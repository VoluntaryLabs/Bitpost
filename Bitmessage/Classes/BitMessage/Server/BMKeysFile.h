//
//  BMKeysFile.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/22/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMKeysFile : NSObject

@property (strong) NSMutableDictionary *dict;

- (void)setupForDaemon;
- (BOOL)setApiUsername:(NSString *)aString;
- (BOOL)setApiPassword:(NSString *)aString;
- (BOOL)setLabel:(NSString *)aLabel onAddress:(NSString *)anAddress;

- (void)backup;

@end
