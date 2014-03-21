//
//  MKAskMessage.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/20/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMessage.h"

@interface MKAskMessage : MKMessage

@property (strong, nonatomic) NSArray *category;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;

@property (strong, nonatomic) NSNumber *quanityNumber;
@property (strong, nonatomic) NSString *quanityUnit;

@property (strong, nonatomic) NSNumber *priceNumber;
@property (strong, nonatomic) NSString *priceCurrency;

@end
