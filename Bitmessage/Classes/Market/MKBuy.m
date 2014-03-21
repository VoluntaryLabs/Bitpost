//
//  MKBuy.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKBuy.h"
#import "MKMessage.h"

@implementation MKBuy

- (NSString *)nodeTitle
{
    return [self.dict objectForKey:@"id"];
}

- (void)setDict:(NSMutableDictionary *)aDict
{
    /*
    NSMutableArray *children = [NSMutableArray array];
    
    for (NSString *k in aDict.allKeys)
    {
        NSMutableDictionary *messageDict = [aDict objectForKey:k];
        MKMessage *msg = [MKMessage withDict:messageDict];
        [children addObject:msg];
    }
    
    [self setChildren:children];
    */
}

- (NSMutableDictionary *)dict
{
    
    return nil;
}

@end
