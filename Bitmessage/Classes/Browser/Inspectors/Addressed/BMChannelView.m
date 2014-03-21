//
//  BMChannelView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/20/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMChannelView.h"

@implementation BMChannelView

- (void)setup
{
    [super setup];
    [self.addressField setEditable:NO];
    [self.addressField setDelegate:nil];
}

- (void)updateContact
{
    //if (self.contact.isValidAddress)
    {
        [self.contact update];
    }
}

@end
