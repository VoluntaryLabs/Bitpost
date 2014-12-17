//
//  BMMessage+NodeView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "BMMessage+NodeView.h"
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import <NavKit/NavKit.h>
#import "BMDraftController.h"
#import "BMMessageView.h"

@implementation BMMessage (NodeView)

- (void)initCategory
{
    [super initCategory];
    
    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"reply"];
        [slot setVisibleName:@"reply"];
    }
    
    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"forward"];
        [slot setVisibleName:@"forward"];
    }
}

- (NSString *)nodeNote
{
    return self.date.itemDateString;
}

- (NSString *)quotedMessage
{
    NSString *date = [[self date]
                      descriptionWithCalendarFormat:@"%b %d" timeZone:nil
                      locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    
    NSString *s = ((BMMessageView *)self.nodeView).selectedContent;
    
    if (s == nil || [s length] == 0)
    {
        s = self.message.decodedBase64;
    }
    
    NSString *q =  [s stringByReplacingOccurrencesOfString:@"\n" withString:@"\n> "];
    q =  [@"> " stringByAppendingString:q];
    
    
    return [NSString stringWithFormat:@"\n\n\nOn %@, %@ wrote:\n%@\n", date, [self fromAddressLabel], q];
}

- (void)reply // move to draft class
{
    BMDraftController *draft = [BMDraftController openNewDraft];
    
    [draft.to setStringValue:self.fromAddress];
    [draft.from setStringValue:self.toAddress];
    //[draft setDefaultFrom];
    [draft setAddressesToLabels];
    [draft.subject setStringValue:self.subjectString];
    [draft addSubjectPrefix:@"Re: "];
    [draft setBodyString:self.quotedMessage];
    [draft setCursorForReply];
    [draft open];
}

- (void)forward // move to draft class
{
    BMDraftController *draft = [BMDraftController openNewDraft];

    [draft setDefaultFrom];
    [draft setAddressesToLabels];
    [draft.subject setStringValue:self.subjectString];
    [draft addSubjectPrefix:@"Fwd: "];
    [draft setBodyString:self.quotedMessage];
    [draft setCursorOnTo];
    [draft open];
}


- (Class)viewClass
{
    return [BMMessageView class];
}

@end
