//
//  BMContact.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMContact.h"
#import "BMProxyMessage.h"
#import "NSString+BM.h"

#import "DraftController.h"
#import "AppController.h"
#import "BMClient.h"
#import "BMIdentities.h"
#import "BMAddress.h"

@implementation BMContact

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"message", @"delete", nil];
    return self;
}

+ (BMContact *)withDict:(NSDictionary *)dict
{
    id instance = [[[self class] alloc] init];
    [instance setDict:dict];
    return instance;
}

- (NSDictionary *)dict
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

- (NSString *)nodeTitle
{
    return self.label;
}

/*
- (NSString *)nodeSubtitle
{
    return self.address;
}
 */

// -----

- (void)justDelete
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"deleteAddressBookEntry"];
    NSArray *params = [NSArray arrayWithObjects:self.address, nil];
    [message setParameters:params];
    message.debug = YES;
    [message sendSync];
    id response = [message parsedResponseValue];
    NSLog(@"delete response = %@", response);
}

- (void)delete
{
    [self justDelete];
    [self.nodeParent removeChild:self];
}

- (void)update
{
    NSLog(@"updating contact '%@' '%@'", self.address, self.label);
    
    [self justDelete];
    
    if([self insert])
    {
        [self postParentChanged];
    }
}

- (BOOL)insert
{
    NSLog(@"inserting contact '%@' '%@'", self.address, self.label);
    
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"addAddressBookEntry"];
    NSArray *params = [NSArray arrayWithObjects:self.address, self.label.encodedBase64, nil];
    [message setParameters:params];
    //message.debug = YES;
    [message sendSync];
    
    id response = [message parsedResponseValue];
    NSLog(@"insert response = %@", response);
    
    if ([response isKindOfClass:[NSString class]] && [response containsString:@"Error"])
    {
        return NO;
    }

    [self.nodeParent addChild:self];

    return YES;
}

- (void)message
{
    AppController *appController = (AppController *)[[NSApplication sharedApplication] delegate];
    DraftController *draftController = [appController newDraft];
    
    [draftController.to setStringValue:self.address];
    
    NSString *from = [[[BMClient sharedBMClient] identities] firstIdentityAddress];
    
    if (from)
    {
        [draftController.from setStringValue:from];
    }
    
    [draftController.subject becomeFirstResponder];
    [draftController updateSendButton];
}

@end
