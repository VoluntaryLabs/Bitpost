//
//  MKSells.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSells.h"
#import "MKSell.h"

@implementation MKSells

- (id)init
{
    self = [super init];
    //self.actions = [NSMutableArray arrayWithObjects:@"add", nil];
    [self add];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Sells";
}

- (MKSell *)justAdd
{
    MKSell *sell = [[MKSell alloc] init];
    [self addChild:sell];
    return sell;
}

- (void)add
{
    //MKSell *sell =
    [self justAdd];
    //[self postParentChanged];
}

@end
