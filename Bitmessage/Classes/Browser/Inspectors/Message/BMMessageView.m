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
//#import "DraftController.h"
//#import "AppController.h"
#import "NSString+BM.h"
#import "MarginTextView.h"
#import "BMContacts.h"
#import "BMSentMessage.h"

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

- (NSMutableDictionary *)infoAttributes
{
    NSFont *font = [NSFont fontWithName:@"Open Sans Light" size:14.0];
    NSMutableDictionary *att = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSColor colorWithCalibratedWhite:.3 alpha:1.0], NSForegroundColorAttributeName,
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

- (NSMutableDictionary *)linkAttributes
{
    NSFont *font = [NSFont fontWithName:@"Open Sans Light" size:14.0];
    NSMutableDictionary *att = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                //[NSColor colorWithRed:0.70/2.0 green:0.69/2.0 blue:0.98/2.0 alpha:1.0f], NSForegroundColorAttributeName,
                                [NSColor colorWithRed:0.70 green:0.69 blue:0.98 alpha:1.0], NSForegroundColorAttributeName,
                         font, NSFontAttributeName,
                         [NSNumber numberWithInt:NSUnderlineStyleNone], NSUnderlineStyleAttributeName,
                         nil];
    return att;
}


- (NSMutableAttributedString *)linkForAddress:(NSString *)address
{
    NSMutableDictionary *att = [self infoAttributes];
    
    if ([address hasPrefix:@"BM-"])
    {
        att = [self linkAttributes];
        [att setObject:[NSString stringWithFormat:@"BitmessageAddContact://%@", address] forKey:NSLinkAttributeName];
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]
                                                initWithString:address
                                                attributes:att];

    return string;
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
                                                initWithString:[NSString stringWithFormat:@"%@\n", self.message.subjectString]
                                                attributes:[self subjectAttributes]];

    [subjectString appendAttributedString:[self linkForAddress:self.message.fromAddressLabel]];
    
    [subjectString appendAttributedString:[[NSMutableAttributedString alloc]
                                           initWithString:@" → "
                                           attributes:[self infoAttributes]]];
    
    [subjectString appendAttributedString:[self linkForAddress:self.message.toAddressLabel]];
    
    if (self.message.class == [BMSentMessage class])
    {
        NSString *status = ((BMSentMessage *)self.message).getHumanReadbleStatus;
        
        if (status)
        {
            [subjectString appendAttributedString:[[NSMutableAttributedString alloc]
                                                   initWithString:[NSString stringWithFormat:@" (%@)", status]
                                                   attributes:[self infoAttributes]]];
        }
    }
    
    [subjectString appendAttributedString:[[NSMutableAttributedString alloc]
                                           initWithString:@"\n"
                                           attributes:[self infoAttributes]]];
    
    
     /*
     NSMutableAttributedString *string; // assume string exists
     NSRange selectedRange; // assume this is set
     
     NSURL *linkURL = [NSURL URLWithString:@"http://www.apple.com/"];
     
     [string beginEditing];
     [string addAttribute:NSLinkAttributeName
     value:linkURL
     range:selectedRange];
     
     [string addAttribute:NSForegroundColorAttributeName
     value:[NSColor blueColor]
     range:selectedRange];
     
     [string addAttribute:NSUnderlineStyleAttributeName
     value:[NSNumber numberWithInt:NSSingleUnderlineStyle]
     range:selectedRange];
     [string endEditing];
     */
    
    /*
    NSMutableAttributedString *bodyString = [[NSMutableAttributedString alloc]
                                                initWithString:self.message.messageString
                                                attributes:[self bodyAttributes]];
    
     */
    
    NSMutableAttributedString *bodyString = self.message.messageAttributedString;

    [bodyString setAttributes:[self bodyAttributes] range:NSMakeRange(0, [bodyString length])];

    [subjectString appendAttributedString:[[NSMutableAttributedString alloc]
                                 initWithString:@"\n"
                                 attributes:[self bodyAttributes]]];
    
    [subjectString appendAttributedString:bodyString];
    
    //NSMutableAttributedString *subjectString = [[NSMutableAttributedString alloc] initWithString:aString];


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
    BOOL isFirstTime = (_node == nil);
    _node = node;
    
    //[self.textView setString:message.messageString];
    //[self.textView setFont:nil];
    
    [self.textView setRichText:YES];
    [self.textView setEditable:NO];
    [self.textView setString:@""];
    //[self.textView insertText:self.bodyString];
    [self.textView.textStorage setAttributedString:[self bodyString]];
    [self.textView setWidth:self.frame.size.width];
    
    if (isFirstTime)
    {
        [[self.scrollView contentView] scrollToPoint:NSMakePoint (0, 0)];
        [self.scrollView reflectScrolledClipView: [self.scrollView contentView]];
    }
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
    
    [self.textView setLinkTextAttributes:[self linkAttributes]];
    [self.textView setDelegate:self];
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

- (void)prepareToDisplay
{
    
}

- (BOOL)textView:(NSTextView *)aTextView
   clickedOnLink:(id)link
        atIndex:(NSUInteger)charIndex
{
    NSArray *parts = [link componentsSeparatedByString:@"://"];
    NSString *command = [parts objectAtIndex:0];
    NSString *argument = [parts objectAtIndex:1];

    NSLog(@"clickedOnLink %@", link);
    
    if ([command isEqualToString:@"BitmessageAddContact"])
    {
        BMClient *client = [BMClient sharedBMClient];
        BMContacts *contacts = [client contacts];
        BMContact *newContact = [contacts justAdd];
        [newContact setAddress:argument];
        
        NSArray *nodes = [NSArray arrayWithObjects:client, contacts, newContact, nil];
        [self.navView selectNodePath:nodes];
        return YES; // yes, we handled it
    }
     
    return NO;
}

@end



