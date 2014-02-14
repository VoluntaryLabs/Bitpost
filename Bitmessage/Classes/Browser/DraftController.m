//
//  DraftController.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/9/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "DraftController.h"
#import "NSView+sizing.h"
#import "BMMessage.h"
#import "BMClient.h"
#import "BMIdentity.h"

@implementation DraftController

- (id)init
{
    self = [super init];
    return self;
}

- (NSWindow *)window
{
    return self.view.window;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    [self setupViewPositions];
    [self setupHighlightColors];
    [self setupNotifications];
    [self setupDefaultValues];
    [self updateWindow];
    [self.window setDelegate:self];
}

- (void)setupViewPositions
{
    
    [self.bodyArea setBackgroundColor:[NSColor whiteColor]];
    [self.bodyArea setNeedsDisplay:YES];
    [self.topBackground setBackgroundColor:[NSColor colorWithCalibratedWhite:.95 alpha:1.0]];
    [self removeFocusRings];

    NSColor *textColor = [NSColor colorWithCalibratedWhite:.7 alpha:1.0];
    [self.to setTextColor:textColor];
    [self.from setTextColor:textColor];
    [self.subject setTextColor:textColor];
    
    //[[self.to      superview] setY:[self.from superview].maxY + 2];
    [[self.to superview] setY:[self.from superview].y - [self.to superview].height - 1];
    [[self.subject superview] setY:[self.to superview].y - [self.subject superview].height - 1];

    
    [self.topBackground setX:0];
    [self.topBackground setWidth:((NSView *)self.window.contentView).frame.size.width];
    
    [self.topBackground setY:[self.subject superview].y -1];
    [self.topBackground setHeight:[self.from superview].maxY - [self.subject superview].y];
    
    [self.scrollView setY:0];
    [self.scrollView setHeight:self.topBackground.y -0];
    
    [[self bodyText] setFont:[NSFont fontWithName:@"Open Sans Light" size:14]];
    [[self bodyText] setTextColor:textColor];
    
    
    CGFloat margin = 20.0;
    self.marginView = [[ColoredView alloc] initWithFrame:NSMakeRect(0, 0, margin, self.scrollView.height)];
    self.marginView.backgroundColor = [NSColor whiteColor];
    [self.scrollView.superview addSubview:self.marginView];
    
    [self.scrollView setX:margin];
    [self.scrollView setWidth:self.scrollView.superview.width - margin];
}

- (void)setupHighlightColors
{
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSColor colorWithCalibratedWhite:.01 alpha:0.15], NSBackgroundColorAttributeName,
                         nil];
    NSTextView *tv;
    
    tv = (NSTextView *)[self.window fieldEditor:YES forObject:self.to];
    [tv setSelectedTextAttributes:att];
    
    tv = (NSTextView *)[self.window fieldEditor:YES forObject:self.from];
    [tv setSelectedTextAttributes:att];
    
    tv = (NSTextView *)[self.window fieldEditor:YES forObject:self.subject];
    [tv setSelectedTextAttributes:att];
}

- (void)setupNotifications
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSendButton) name:NSControlTextDidChangeNotification object:self.from];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSendButton) name:NSControlTextDidChangeNotification object:self.to];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSendButton) name:NSControlTextDidChangeNotification object:self.subject];

}

- (void)setupDefaultValues
{
    BMIdentities *ids = [[BMClient sharedBMClient] identities];
    BMIdentity *identity = [[ids children] firstObject];
    
    if (identity)
    {
        [self.from setStringValue:identity.address];
        //[self.to setStringValue:identity.address];
        [self.to setStringValue:@"BM-orkCbppXWSqPpAxnz6jnfTZ2djb5pJKDb"];
    }
}

- (void)updateWindow
{
    // to get widnow to redraw - not sure why we have to do it this way
    NSRect r = self.window.frame;
    r.size.width ++;
    [self.window setFrame:r display:YES];
    //[self.bodyText becomeFirstResponder];
    [self updateSendButton];
}
    
- (void)removeFocusRings
{
    [self.from setFocusRingType:NSFocusRingTypeNone];
    [self.to setFocusRingType:NSFocusRingTypeNone];
    [self.subject setFocusRingType:NSFocusRingTypeNone];
}

- (NSString *)fromAddress
{
    return self.from.stringValue;
}

- (NSString *)toAddress
{
    return self.to.stringValue;
}

- (BOOL)canSend
{
    return ![self.fromAddress isEqualToString:@""] &&
    ![self.toAddress isEqualToString:@""];
}

- (IBAction)send:(id)sender
{
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:self.fromAddress];
    [m setToAddress:self.toAddress];
    [m setSubject:self.subject.stringValue];
    [m setMessage:self.bodyText.string];
    [m send];
    
    [[[[BMClient sharedBMClient] messages] sent] refresh];
    [self close];
}

- (void)updateSendButton
{
    if([self canSend])
    {
        [self.sendButton setImage:[NSImage imageNamed:@"Reply_active"]];
    }
    else
    {
        [self.sendButton setImage:[NSImage imageNamed:@"Reply_inactive"]];
    }
}

- (void)close
{
    [self.window orderOut:self];
}

- (BOOL)windowShouldClose:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"draftClosed" object:self];
    return YES;
}

- (void)setCursorForReply
{
    NSInteger charIndex = 1;
    [self.bodyText setSelectedRange: NSMakeRange(charIndex, 0)];
    [self.scrollView becomeFirstResponder];
    //[self.bodyText becomeFirstResponder];
}

@end
