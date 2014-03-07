//
//  BMAddressed.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddressed.h"
#import "BMAddress.h"

#import "AppController.h"
#import "BMClient.h"
#import "BMReceivedMessage.h"

#import "Theme.h"

@implementation BMAddressed

+ (NSString *)defaultLabel
{
    return @"Enter Name";
}

- (id)init
{
    self = [super init];
    //self.actions = [NSMutableArray arrayWithObjects:@"message", @"delete", nil];
    return self;
}

+ (id)withDict:(NSDictionary *)dict
{
    id instance = [[[self class] alloc] init];
    [instance setDict:dict];
    return instance;
}

- (NSMutableDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self.label encodedBase64] forKey:@"label"];
    [dict setObject:self.address forKey:@"address"];
    return dict;
}

- (void)setDict:(NSDictionary *)dict
{
    self.label   = [[dict objectForKey:@"label"] decodedBase64];
    self.address = [dict objectForKey:@"address"];
}

- (BOOL)hasUnsetLabel
{
    return [self.label isEqualToString:[[self class] defaultLabel]];
}

- (NSString *)nodeTitle
{
    return self.label;
}

- (NSString *)visibleLabel
{
    return self.label;
}

- (void)setVisibleLabel:(NSString *)aLabel
{
    self.label = aLabel;
}

- (BOOL)isValidAddress
{
    return [BMAddress isValidAddress:self.address];
}

- (BOOL)canLiveUpdate
{
    return NO;
}

// -----------------------

- (void)message
{
    AppController *appController = (AppController *)[[NSApplication sharedApplication] delegate];
    DraftController *draftController = [appController newDraft];
    
    [draftController.to setStringValue:self.address];
    
    NSString *from = [[[[BMClient sharedBMClient] identities] firstIdentity] address];
    
    if (from)
    {
        [draftController.from setStringValue:from];
    }
    
    [draftController.subject becomeFirstResponder];
    [draftController open];
}

/*
- (NSMutableArray *)children
{
    // should we have TO and FROM children instead
    return [[[BMClient sharedBMClient] messages] inboxMessagesFromAddress:self.address];
}
*/

// UI - move to category

- (CGFloat)nodeSuggestedWidth
{
    return 350.0;
}

- (NSColor *)columnBgColor
{
    return [Theme objectForKey:[NSString stringWithFormat:@"Messages-columnBgColor"]];
}

@end

