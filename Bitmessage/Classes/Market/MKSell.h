//
//  MKSell.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitMessageKit/BitMessageKit.h>
#import "MKAskMessage.h"

@interface MKSell : BMNode

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) MKAskMessage *askMessage;

//- (NSDictionary *)propertiesDict;


@end
