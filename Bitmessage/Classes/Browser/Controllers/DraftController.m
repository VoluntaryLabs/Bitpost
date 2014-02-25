//
//  DraftController.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/9/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "DraftController.h"
#import "NSView+sizing.h"
#import "NSString+BM.h"
#import "BMMessage.h"
#import "BMClient.h"
#import "BMIdentity.h"
#import "NSString+BM.h"
#import "BMAddress.h"
#import "AppController.h"

@implementation DraftController

+ (DraftController *)openNewDraft
{
    DraftController *draft = [[DraftController alloc] initWithNibName:@"Compose" bundle:nil];
    
    // place window
    
    NSRect f = [[NSApplication sharedApplication] mainWindow].frame;
    NSPoint topLeft = f.origin;
    topLeft.y += f.size.height;
    topLeft.y -= 20;
    topLeft.x += 20;
    NSWindow *window = [[draft view] window];
    [window setFrameTopLeftPoint:topLeft];
    [window makeKeyAndOrderFront:self];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"draftOpened" object:self];
    //AppController *appDelegate = (AppController *)[[NSApplication sharedApplication] delegate];
    //[appDelegate.drafts addObject:self];
    
    return draft;
}

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
    
    [self.to setDelegate:self];
    [self.from setDelegate:self];
}


- (NSColor *)fieldTextColor
{
    return [NSColor colorWithCalibratedWhite:.7 alpha:1.0];
}

- (void)setupViewPositions
{
    [self.bodyArea setBackgroundColor:[NSColor whiteColor]];
    [self.bodyArea setNeedsDisplay:YES];
    [self.topBackground setBackgroundColor:[NSColor colorWithCalibratedWhite:.95 alpha:1.0]];
    [self removeFocusRings];

    [self.to setTextColor:self.fieldTextColor];
    [self.from setTextColor:self.fieldTextColor];
    [self.subject setTextColor:self.fieldTextColor];
    
    //[[self.to      superview] setY:[self.from superview].maxY + 2];
    [[self.to superview] setY:[self.from superview].y - [self.to superview].height - 1];
    [[self.subject superview] setY:[self.to superview].y - [self.subject superview].height - 1];

    
    [self.topBackground setX:0];
    [self.topBackground setWidth:((NSView *)self.window.contentView).frame.size.width];
    
    [self.topBackground setY:[self.subject superview].y -1];
    [self.topBackground setHeight:[self.from superview].maxY - [self.subject superview].y];

    [self.scrollView setX:0];
    [self.scrollView setY:0];
    [self.scrollView setHeight:self.topBackground.y -0];
    [self.scrollView setWidth:self.scrollView.superview.width];
    
    [[self bodyText] setFont:[NSFont fontWithName:@"Open Sans" size:13]];
    NSColor *bodyTextColor = [NSColor colorWithCalibratedWhite:.5 alpha:1.0];
    [[self bodyText] setTextColor:bodyTextColor];
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
    return [self hasValidAddresses];
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
    [self.from setStringValue:self.from.stringValue.strip];
    [self.to setStringValue:self.to.stringValue.strip];
    
    if([self canSend])
    {
        [self.sendButton setImage:[NSImage imageNamed:@"send_active"]];
        [self.sendButton setEnabled:YES];
    }
    else
    {
        [self.sendButton setImage:[NSImage imageNamed:@"send_inactive"]];
        [self.sendButton setEnabled:NO];
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

// --- delegate ---

- (BOOL)hasValidAddresses
{
    return
        [BMAddress isValidAddress:[self.to.stringValue strip]] &&
        [BMAddress isValidAddress:[self.from.stringValue strip]];
}

-(void)controlTextDidChange:(NSNotification *)note
{
    NSLog(@"draft controlTextDidChange");

    NSTextField *field = [note object];
    NSString *address = [field.stringValue strip];
    
    if ([BMAddress isValidAddress:address])
    {
        field.textColor = self.fieldTextColor;
    }
    else
    {
        field.textColor = [NSColor redColor];
    }
}

- (NSArray *)control:(NSControl *)control
            textView:(NSTextView *)textView
         completions:(NSArray *)words
 forPartialWordRange:(NSRange)charRange
 indexOfSelectedItem:(NSInteger *)index
{
    
    return @[@"foobar", @"foobaz", @"fooqaz"];
}

@end
