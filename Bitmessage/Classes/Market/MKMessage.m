//
//  MKMessage.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMessage.h"

@implementation MKMessage

- (NSString *)nodeTitle
{
    return NSStringFromClass([self class]);
}

- (NSString *)nodeSubtitle
{
    //return self.date.description;
    return nil;
}


- (MKMessage *)withDict:(NSMutableDictionary *)dict
{
    return nil;
}

@end
