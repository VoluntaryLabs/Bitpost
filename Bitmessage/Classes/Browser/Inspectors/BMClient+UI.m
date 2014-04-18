//
//  BMClient+UI.m
//  Bitmessage
//
//  Created by Steve Dekorte on 4/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMClient+UI.h"
#import "DraftController.h"

@implementation BMClient (UI)

- (NSArray *)uiActions
{
    NSArray *uiActions = [NSMutableArray arrayWithObjects:@"compose", nil];
    return  [uiActions arrayByAddingObjectsFromArray:super.uiActions];
}

- (void)compose
{
    DraftController *draft = [DraftController openNewDraft];
    [draft setDefaultFrom];
    [draft setCursorOnTo];
    [draft open];
}

@end
