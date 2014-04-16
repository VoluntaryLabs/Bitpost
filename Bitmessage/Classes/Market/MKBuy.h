//
//  MKBuy.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BitMessageKit.h>

@interface MKBuy : BMNode

- (void)setDict:(NSMutableDictionary *)aDict;
- (NSMutableDictionary *)dict;

@end
