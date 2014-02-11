//
//  BMMessageView.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMMessageView.h"
#import "BMMessage.h"
#import "NSView+sizing.h"
#import "ResizingScrollView.h"


@implementation BMMessageView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    [self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    [self setupBody];
    _margin = 15.0;
    return self;
}

- (NSString *)fontName
{
    //return @"Open Sans Light";
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
    
    /*
    self.marginView.bounds = self.textView.bounds;
    [self.scrollView setDocumentView:self.marginView];
    
    NSLayoutManager *layoutManager = self.textView.layoutManager;
    NSTextContainer *textContainer = self.textView.textContainer;
    NSRange r = NSMakeRange(0, [self.textView.textStorage characters].count);
    
    [layoutManager ensureLayoutForCharacterRange:r];
    NSRect b = [layoutManager boundingRectForGlyphRange:r inTextContainer:textContainer];
    self.textView.frame = b;
    */
}

- (void)setupBody
{
    CGFloat margin = 30.0;
    NSRect f = self.frame;
    f.origin.x += margin;
    f.size.width -= margin*2;
    
    self.scrollView = [[ResizingScrollView alloc] initWithFrame:f];
    [self addSubview:self.scrollView];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalRuler:NO];
    [self.scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
    [self.scrollView setAutoresizesSubviews:YES];
    [self.scrollView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    
    ///self.marginView = [[NSView alloc] initWithFrame:self.scrollView.bounds];
    //[self.scrollView setDocumentView:self.marginView];
    //[self.marginView setAutoresizesSubviews:YES];
    //[self.marginView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    
    self.textView = [[NSTextView alloc] initWithFrame:self.scrollView.bounds];
    [self.scrollView setDocumentView:self.textView];
    
    [self.textView setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      //[NSColor blackColor], NSBackgroundColorAttributeName,
      [NSColor colorWithCalibratedWhite:1.0 alpha:0.15], NSBackgroundColorAttributeName, //NSForegroundColorAttributeName,
      nil]];
    
    //[self.marginView addSubview:self.textView];
    //[self.textView setAutoresizesSubviews:YES];
    //[self.textView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    [self.textView setBackgroundColor:[NSColor colorWithCalibratedWhite:018.0/255.0 alpha:1.0]];
    //[self.textView setBackgroundColor:[NSColor whiteColor]];
    //[self.textView setTextColor:[NSColor colorWithCalibratedWhite:198.0/255.0 alpha:1.0]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [self.textView.backgroundColor set];
    [NSBezierPath fillRect:dirtyRect];
}

@end

// ---------------------------------------------

#import "Theme.h"

@implementation BMMessage (NodeView)

- (NSView *)nodeView
{
    if (![super nodeView])
    {
        self.nodeView = [[BMMessageView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    }
    return [super nodeView];
}

- (NSColor *)textColor
{
    NSString *className = NSStringFromClass([self class]);
    
    if (self.read)
    {
        return [Theme objectForKey:[NSString stringWithFormat:@"%@-readTextColor", className]];
    }
    
    return [Theme objectForKey:[NSString stringWithFormat:@"%@-unreadTextColor", className]];
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
        NSInteger weeks = days/7;
        
        if (hours < 1)
        {
            return [NSString stringWithFormat:@"%im", (int)mins];
        }
        
        if (hours < 1)
        {
            return [NSString stringWithFormat:@"%ih", (int)hours];
        }

        if (weeks < 1)
        {
            return [NSString stringWithFormat:@"%iw", (int)days];
        }

        return [date
                  descriptionWithCalendarFormat:@"%b %d" timeZone:nil
                  locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    }
    
    return @"";
}

@end
