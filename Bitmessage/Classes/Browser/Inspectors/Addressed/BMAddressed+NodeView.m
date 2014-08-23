//
//  BMAddressed+NodeView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 4/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "BMAddressed+NodeView.h"
#import "BMDraftController.h"
#import <BitMessageKit/BitMessageKit.h>

@implementation BMAddressed (NodeView)


- (void)message
{
    BMDraftController *draftController = [BMDraftController openNewDraft];
    
    [draftController.to setStringValue:self.address];
    
    NSString *from = [[[BMClient.sharedBMClient identities] firstIdentity] address];
    
    if (from)
    {
        [draftController.from setStringValue:from];
    }
    
    [draftController.subject becomeFirstResponder];
    [draftController open];
}

@end
