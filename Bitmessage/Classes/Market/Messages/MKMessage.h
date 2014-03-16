//
//  MKMessage.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKMessage : NSObject

@property (retain, nonatomic) NSString *service;
@property (retain, nonatomic) NSString *msg;

@end
