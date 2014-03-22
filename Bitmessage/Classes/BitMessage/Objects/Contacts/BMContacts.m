//
//  BMContacts.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMContacts.h"
#import "BMProxyMessage.h"

@implementation BMContacts

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"add", nil];
    self.shouldSelectChildOnAdd = YES;
    return self;
}

- (void)fetch
{
    [self setChildren:[self listAddressBookEntries]];
    [self sortChildren];
}


- (NSMutableArray *)listAddressBookEntries // contacts
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"listAddressBookEntries"];
    NSArray *params = [NSArray arrayWithObjects:nil];
    [message setParameters:params];
    [message sendSync];
    
    NSMutableArray *contacts = [NSMutableArray array];
    
    //NSLog(@"\n[message parsedResponseValue] = %@", [message parsedResponseValue]);
    
    NSArray *dicts = [[message parsedResponseValue] objectForKey:@"addresses"];
    
    
    for (NSDictionary *dict in dicts)
    {
        BMContact *contact = [BMContact withDict:dict];
        [contacts addObject:contact];
    }
    
    //NSLog(@"\n\n contacts = %@", contacts);
    
    return contacts;
}

- (BMContact *)justAdd
{
    BMContact *newContact = [[BMContact alloc] init];
    [newContact setLabel:@"Enter Name"];
    [newContact setAddress:@"Enter Bitmessage Address"];
    //[newContact insert];
    [self addChild:newContact];
    return newContact;
}

- (void)add
{
    [self justAdd];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BMNodeChanged" object:self];
}

- (NSString *)nodeTitle
{
    return @"Contacts";
}


@end
