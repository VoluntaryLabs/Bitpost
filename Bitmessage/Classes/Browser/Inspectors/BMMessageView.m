//
//  BMMessageView.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMMessageView.h"
#import "BMMessage.h"
#import "BMClient.h"
#import "NSView+sizing.h"
#import "ResizingScrollView.h"
#import "DraftController.h"
#import "AppController.h"
#import "NSString+BM.h"
#import "MarginTextView.h"

@implementation BMMessageView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    [self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    [self setupBody];
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc BMMessageView %p", (__bridge void *)self);
}

- (NSString *)fontName
{
    return @"Open Sans Light";
}

- (NSDictionary *)subjectAttributes
{
    NSFont *font = [NSFont fontWithName:@"Open Sans Light" size:25.0];
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSColor colorWithCalibratedWhite:.9 alpha:1.0], NSForegroundColorAttributeName,
                                    font, NSFontAttributeName,
                                    nil];
    return att;
}

- (NSDictionary *)bodyAttributes
{
    NSFont *font = [NSFont fontWithName:@"Open Sans Light" size:14.0];
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSColor colorWithCalibratedWhite:.5 alpha:1.0], NSForegroundColorAttributeName,
                                    font, NSFontAttributeName,
                                    nil];
    return att;
}

- (NSAttributedString *)bodyString
{
    NSMutableParagraphStyle *indented = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    
    [indented setAlignment:NSLeftTextAlignment];
    [indented setLineSpacing:1.0];
    [indented setParagraphSpacing:1.0];
    [indented setHeadIndent:0.0];
    [indented setTailIndent:0.0];
    //[indented setFirstLineHeadIndent:45.0];
    [indented setLineBreakMode:NSLineBreakByWordWrapping];

    [self.message markAsRead];
    
    NSMutableAttributedString *subjectString = [[NSMutableAttributedString alloc]
                                                initWithString:[NSString stringWithFormat:@"\n%@\n", self.message.subjectString]
                                                attributes:[self subjectAttributes]];

 
    NSMutableAttributedString *bodyString = [[NSMutableAttributedString alloc]
                                                initWithString:[@"\n" stringByAppendingString:self.message.messageString]
                                                attributes:[self bodyAttributes]];
    
    [subjectString appendAttributedString:bodyString];
    
    //NSMutableAttributedString *subjectString = [[NSMutableAttributedString alloc] initWithString:aString];

    //[subjectString setAttributes:[self subjectAttributes] range:NSMakeRange(0, [aString length])];

    [subjectString addAttribute:NSParagraphStyleAttributeName
                      value:indented
                      range:NSMakeRange(0, [subjectString length])];
    
    return subjectString;
}

- (BMMessage *)message
{
    return (BMMessage *)self.node;
}

- (void)setNode:(id<NavNode>)node
{
    _node = node;
    
    //[self.textView setString:message.messageString];
    //[self.textView setFont:nil];
    [self.textView setEditable:YES];
    [self.textView setString:@""];
    [self.textView insertText:self.bodyString];
    /*
    [self.textView insertText:message.subjectString];
    [self.textView insertText:@"\n\n\n"];
    [self.textView insertText:message.messageString];
     */
    [self.textView setEditable:NO];
    [self.textView.textStorage setAttributedString:[self bodyString]];
    [self.textView setWidth:self.frame.size.width];
    

    NSPoint pointToScrollTo = NSMakePoint (0, 0);  // Any point you like.
    [[self.scrollView contentView] scrollToPoint: pointToScrollTo];
    [self.scrollView reflectScrolledClipView: [self.scrollView contentView]];
}

- (void)setupBody
{
    NSRect f = self.frame;
    
    self.scrollView = [[ResizingScrollView alloc] initWithFrame:f];
    [self addSubview:self.scrollView];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalRuler:NO];
    [self.scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
    [self.scrollView setAutoresizesSubviews:YES];
    [self.scrollView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    
    self.textView = [[MarginTextView alloc] initWithFrame:self.scrollView.bounds];
    [self.scrollView setDocumentView:self.textView];
    
    [self.textView setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      //[NSColor blackColor], NSBackgroundColorAttributeName,
      [NSColor colorWithCalibratedWhite:1.0 alpha:0.15], NSBackgroundColorAttributeName, //NSForegroundColorAttributeName,
      nil]];

    [self.textView setBackgroundColor:[NSColor colorWithCalibratedWhite:018.0/255.0 alpha:1.0]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [self.textView.backgroundColor set];
    [NSBezierPath fillRect:dirtyRect];
}

- (NSString *)selectedContent
{
    return [[self.textView string]
            substringWithRange:[self.textView selectedRange]];
}

@end

// ---------------------------------------------

#import "Theme.h"

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
    
    if (self.read)
    {
        return [Theme objectForKey:[NSString stringWithFormat:@"%@-readTextColor", className]];
    }
    
    return [Theme objectForKey:[NSString stringWithFormat:@"%@-unreadTextColor", className]];
}

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
    DraftController *draftController = [appController newDraft];

    // set to
    
    NSString *to = [[BMClient sharedBMClient] labelForAddress:self.fromAddress];
    if ([to hasPrefix:@"BM-"])
    {
        to = [[BMClient sharedBMClient] labelForAddress:self.toAddress];
    }
    
    [draftController.to setStringValue:to];
    
    // set from
    
    NSString *from = [[[[BMClient sharedBMClient] identities] firstIdentity] label];
    if (from)
    {
        [draftController.from setStringValue:from];
    }
    
    // set subject
    
    NSString *reSubject = self.subjectString;
    if (![reSubject hasPrefix:@"Re: "])
    {
        reSubject = [@"Re: " stringByAppendingString:reSubject];
    }
    
    [draftController.subject setStringValue:reSubject];
    
    [draftController.bodyText insertText:self.quotedMessage];
    
    [draftController setCursorForReply];
    [draftController open];
}

- (Class)viewClass
{
    return [BMMessageView class];
}

@end
