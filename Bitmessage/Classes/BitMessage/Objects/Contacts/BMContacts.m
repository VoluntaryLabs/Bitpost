//
//  BMContacts.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMContacts.h"
#import "BMServerProxy.h"

@implementation BMContacts

- (id)init
{
    self = [super init];
    return self;
}

- (void)fetch
{
    self.children = [[BMServerProxy sharedBMServerProxy] listAddressBookEntries];
}

- (BMContact *)contactWithAddress:(NSString *)address
{
    for (BMContact *contact in self.children)
    {
        if ([contact.address isEqualToString:address])
        {
            return contact;
        }
    }
    return nil;
}


@end
