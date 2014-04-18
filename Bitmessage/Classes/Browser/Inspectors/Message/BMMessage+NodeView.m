//
//  BMMessage+NodeView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMMessage+NodeView.h"
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import <NavKit/NavKit.h>
#import "DraftController.h"
#import "AppController.h"
#import "BMMessageView.h"

@implementation BMMessage (NodeView)

- (NSArray *)uiActions
{
    NSArray *uiActions = [NSMutableArray arrayWithObjects:@"reply", @"forward", nil];
    return  [uiActions arrayByAddingObjectsFromArray:super.uiActions];
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
    DraftController *draft = [DraftController openNewDraft];
    
    [draft.to setStringValue:self.fromAddress];
    [draft setDefaultFrom];
    [draft setAddressesToLabels];
    [draft.subject setStringValue:self.subjectString];
    [draft addSubjectPrefix:@"Re: "];
    [draft setBodyString:self.quotedMessage];
    [draft setCursorForReply];
    [draft open];
}

- (void)forward // move to draft class
{
    DraftController *draft = [DraftController openNewDraft];

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
