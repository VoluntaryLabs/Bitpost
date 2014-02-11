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

@property (retain, nonatomic) NSString *label;
@property (retain, nonatomic) NSString *address;

- (void)createRandomAddress;

@end
