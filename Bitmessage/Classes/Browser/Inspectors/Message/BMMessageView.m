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
#import "NavColumn.h"

@implementation BMMessageView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    [self setThemePath:@"message/body"];
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
    return [Theme.sharedTheme lightFontName];
}

- (NSDictionary *)subjectAttributes
{
    return [Theme.sharedTheme attributesDictForPath:@"message/title"];
    /*
    NSFont *font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:24.0];
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Theme.sharedTheme formText1Color],
                                    NSForegroundColorAttributeName,
                                    font, NSFontAttributeName,
                                    nil];
    return att;
     */
}

- (NSMutableDictionary *)infoAttributes
{
    return [Theme.sharedTheme attributesDictForPath:@"message/subtitle"];
    /*
    NSFont *font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:13.0];
    NSMutableDictionary *att = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [Theme.sharedTheme formText4Color], NSForegroundColorAttributeName,
                         font, NSFontAttributeName,
                         nil];
    return att;
    */
}


- (NSDictionary *)bodyAttributes
{
    NSDictionary *themeDict = [Theme.sharedTheme attributesDictForPath:@"message/body"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:themeDict];
    //[dict setObject:self.dynamicBackgroundColor forKey:NSBackgroundColorAttributeName];
    return dict;
    /*
    NSFont *font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:13.0];
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                         [Theme.sharedTheme formText3Color], NSForegroundColorAttributeName,
                         font, NSFontAttributeName,
                        nil];
    return att;
    */
}

- (NSMutableDictionary *)linkAttributes
{
    return [Theme.sharedTheme attributesDictForPath:@"message/link"];
    /*
    NSFont *font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:14.0];
    NSMutableDictionary *att = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [Theme.sharedTheme formTextLinkColor], NSForegroundColorAttributeName,
                         font, NSFontAttributeName,
                         [NSNumber numberWithInt:NSUnderlineStyleNone], NSUnderlineStyleAttributeName,
                         nil];
    return att;
     */
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
    //[self.message performSelector:@selector(markAsRead) withObject:nil afterDelay:0];
    
    NSMutableAttributedString *fullMessage = [[NSMutableAttributedString alloc] initWithString:@""];
                                                
    NSMutableAttributedString *subjectString = [[NSMutableAttributedString alloc]
                                                initWithString:[NSString stringWithFormat:@"%@\n", self.message.subjectString]
                                                attributes:[self subjectAttributes]];

    [fullMessage appendAttributedString:subjectString];
    [fullMessage appendAttributedString:[self linkForAddress:self.message.fromAddressLabel]];
    
    [fullMessage appendAttributedString:[[NSMutableAttributedString alloc]
                                           initWithString:@" → "
                                           attributes:[self infoAttributes]]];
    
    [fullMessage appendAttributedString:[self linkForAddress:self.message.toAddressLabel]];
    
    if (self.message.class == [BMSentMessage class])
    {
        NSString *status = ((BMSentMessage *)self.message).getHumanReadbleStatus;
        
        if (status)
        {
            [fullMessage appendAttributedString:[[NSMutableAttributedString alloc]
                                                   initWithString:[NSString stringWithFormat:@" (%@)", status]
                                                   attributes:[self infoAttributes]]];
        }
    }
    
    [fullMessage appendAttributedString:[[NSMutableAttributedString alloc]
                                           initWithString:@"\n"
                                           attributes:[self infoAttributes]]];

    [fullMessage appendAttributedString:[[NSMutableAttributedString alloc]
                                         initWithString:@"\n"
                                         attributes:[self subjectAttributes]]];
    
    // body
    
        
    [fullMessage appendAttributedString:[self.message messageStringWithAttributes:self.bodyAttributes]];
    
    //NSMutableAttributedString *bodyString = self.message.messageAttributedString;

/*
    [bodyString setAttributes:[self bodyAttributes] range:NSMakeRange(0, [bodyString length])];

    [subjectString appendAttributedString:[[NSMutableAttributedString alloc]
                                 initWithString:@"\n"
                                 attributes:[self bodyAttributes]]];
    
    [subjectString appendAttributedString:bodyString];
*/

    [fullMessage addAttribute:NSParagraphStyleAttributeName
                      value:indented
                      range:NSMakeRange(0, [subjectString length])];
    
    return fullMessage;
}

- (BMMessage *)message
{
    return (BMMessage *)self.node;
}

- (void)setNode:(id<NavNode>)node
{
    if (_node != node)
    {
        _node = node;
        
        //[self.textView setString:message.messageString];
        //[self.textView setFont:nil];
        
        [self.textView setRichText:YES];
        [self.textView setEditable:NO];
        [self.textView setString:@""];
        [self.textView.textStorage setAttributedString:[self bodyString]];
        [self.textView setWidth:self.frame.size.width];
        

        [[self.scrollView contentView] scrollToPoint:NSMakePoint (0, 0)];
        [self.scrollView reflectScrolledClipView: [self.scrollView contentView]];
        
    }
    
    [self configBody];
}

- (void)setNavView:(id)navView
{
    _navView = navView;
    self.backgroundColor = self.dynamicBackgroundColor;
}

- (NSColor *)dynamicBackgroundColor
{
    NavColumn *column = [self.navView columnForNode:_node];
    ThemeDictionary *theme = [Theme.sharedTheme themeForColumn:column.columnIndex - 1];
    return[theme selectedBgColor];
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
    [self.textView setDelegate:self];
    
    [self configBody];
}

- (void)configBody
{
    [self.textView setThemePath:@"message/background"];
    //[self.textView setBackgroundColor:[Theme.sharedTheme formBackgroundColor]];
    [self.textView setLinkTextAttributes:[self linkAttributes]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [self.textView.backgroundColor set];
    NSRectFill(dirtyRect);
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



