//
//  BMAddressed+message.m
//  Bitmessage
//
//  Created by Steve Dekorte on 4/8/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddressed+message.h"
#import "DraftController.h"
#import <BitMessageKit/BitMessageKit.h>

@implementation BMAddressed (message)


- (void)message
{
    DraftController *draftController = [DraftController openNewDraft];
    
    [draftController.to setStringValue:self.address];
    
    NSString *from = [[[[BMClient sharedBMClient] identities] firstIdentity] address];
    
    if (from)
    {
        [draftController.from setStringValue:from];
    }
    
    [draftController.subject becomeFirstResponder];
    [draftController open];
}

@end
