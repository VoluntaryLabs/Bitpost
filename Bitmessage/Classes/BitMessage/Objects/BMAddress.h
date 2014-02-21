//
//  BMAddress.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/29/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

/*
 <label> [eighteenByteRipe] [totalDifficulty] [smallMessageDifficulty] 
 
 
 */

#import <Foundation/Foundation.h>
#import "BMNode.h"

@interface BMAddress : NSObject

+ (BOOL)isValidAddress:(NSString *)address;

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *status; // (ascii/utf-8)
@property (strong, nonatomic) NSString *addressVersion; // (ascii integer)
@property (strong, nonatomic) NSString *streamNumber; // (ascii integer)
@property (strong, nonatomic) NSString *ripe; // (base64, decodes into binary data) should this be NSData?
@property (assign, nonatomic) BOOL isValid;

- (void)decode;

@end
