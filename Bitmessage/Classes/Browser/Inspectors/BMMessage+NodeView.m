//
//  BMMessage+NodeView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMMessage+NodeView.h"
#import "Theme.h"
#import "DraftController.h"
#import "AppController.h"
#import "BMClient.h"
#import "BMMessageView.h"

@implementation BMMessage (NodeView)

/*
 - (NSView *)nodeView
 {
 if (![super nodeView])
 {
 self.nodeView = [[BMMessageView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
 }
 return [super nodeView];
 }
 */

- (NSColor *)textColor
{
    NSString *className = NSStringFromClass([self class]);
    
    if (!self.read || [self.status isEqualToString:@"msgsent"])
    {
        return [Theme objectForKey:[NSString stringWithFormat:@"%@-unreadTextColor", className]];
    }
    
    return [Theme objectForKey:[NSString stringWithFormat:@"%@-readTextColor", className]];
}
/*
 - (NSColor *)textColor
 {
 NSString *className = NSStringFromClass([self class]);
 
 if (self.read)
 {
 return [Theme objectForKey:[NSString stringWithFormat:@"%@-readTextColor", className]];
 }
 
 return [Theme objectForKey:[NSString stringWithFormat:@"%@-unreadTextColor", className]];
 }
 */

- (NSColor *)textColorActive
{
    NSString *className = NSStringFromClass([self class]);
    return [Theme objectForKey:[NSString stringWithFormat:@"%@-textColorActive", className]];
}

- (NSString *)nodeNote
{
    NSDate *date = self.date;
    
    if (date)
    {
        //return [NSString stringWithFormat:@"%@", date];
        
        NSTimeInterval dt = -[date timeIntervalSinceNow];
        NSInteger mins = dt/60;
        NSInteger hours = mins/60;
        NSInteger days = hours/24;
        //NSInteger weeks = days/7;
        
        NSString *messageYear = [date
                                 descriptionWithCalendarFormat:@"%Y" timeZone:nil
                                 locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        NSString *currentYear = [[NSDate date]
                                 descriptionWithCalendarFormat:@"%Y" timeZone:nil
                                 locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        
        BOOL sameYear = [messageYear isEqualToString:currentYear];
        
        /*
         if (hours < 1)
         {
         return [NSString stringWithFormat:@"%imin", (int)mins];
         }
         */
        
        if (days < 1)
        {
            //return [NSString stringWithFormat:@"%ihr", (int)hours];
            return @"Today";
        }
        
        if (days < 2)
        {
            return @"Yesterday";
        }
        
        /*
         if (weeks < 1)
         {
         return [NSString stringWithFormat:@"%iwk", (int)days];
         }
         */
        
        if (!sameYear)
        {
            return [date
                    descriptionWithCalendarFormat:@"%b %d %Y" timeZone:nil
                    locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        }
        
        return [date
                descriptionWithCalendarFormat:@"%b %d" timeZone:nil
                locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    }
    
    return @"";
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

- (void)reply // hack!
{
    AppController *appController = (AppController *)[[NSApplication sharedApplication] delegate];
    DraftController *draft = [appController newDraft];
    
    // set to
    
    NSString *to = [[BMClient sharedBMClient] labelForAddress:self.fromAddress];
    if ([to hasPrefix:@"BM-"])
    {
        to = [[BMClient sharedBMClient] labelForAddress:self.toAddress];
    }
    
    [draft.to setStringValue:to];
    
    [draft setDefaultFrom];
    
    // set subject
    
    NSString *reSubject = self.subjectString;
    if (![reSubject hasPrefix:@"Re: "])
    {
        reSubject = [@"Re: " stringByAppendingString:reSubject];
    }
    
    [draft.subject setStringValue:reSubject];
    [draft.bodyText insertText:self.quotedMessage];
    [draft setCursorForReply];
    [draft open];
}

- (Class)viewClass
{
    return [BMMessageView class];
}

@end
