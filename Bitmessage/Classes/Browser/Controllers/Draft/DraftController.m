//
//  DraftController.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/9/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "DraftController.h"
#import <BitmessageKit/BitmessageKit.h>
#import <NavKit/NavKit.h>
#import "AppController.h"

NSMutableArray *sharedDrafts = nil;

@implementation DraftController

+ (NSMutableArray *)drafts
{
    if (!sharedDrafts)
    {
        sharedDrafts = [NSMutableArray array];
    }
    
    return sharedDrafts;
}

+ (DraftController *)openNewDraft
{
    DraftController *draft = [[DraftController alloc] initWithNibName:@"Compose" bundle:nil];
    [[[self class] drafts] addObject:draft];
    [draft view]; // to force lazy load
    [draft open];
    return draft;
}

- (void)placeWindow
{
    NSRect f = [[NSApplication sharedApplication] mainWindow].frame;
    NSPoint topLeft = f.origin;
    topLeft.y += f.size.height;
    topLeft.y -= 20;
    topLeft.x += 20;
    NSWindow *window = [[self view] window];
    [window setFrameTopLeftPoint:topLeft];
    [window makeKeyAndOrderFront:self];
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

    NSMutableArray *labels = [[BMClient sharedBMClient] allAddressLabels];
    self.fromCompletor = [[AddressCompletor alloc] init];
    //self.fromCompletor.addressLabels = [[BMClient sharedBMClient] fromAddressLabels];
    self.fromCompletor.addressLabels = labels;
    
    self.toCompletor   = [[AddressCompletor alloc] init];
    //self.toCompletor.addressLabels = [[BMClient sharedBMClient] allAddressLabels];
    self.toCompletor.addressLabels = labels;
    
    [self setupViewPositions];
    [self setupHighlightColors];
    [self setupNotifications];
    [self setupDefaultValues];
    [self updateWindow];
    [self.window setDelegate:self];
    
    //[self.from setDelegate:self.fromCompletor];
    //[self.to   setDelegate:self.toCompletor];
    
    [self.fromCompletor setTextField:self.from];
    [self.toCompletor setTextField:self.to];
}

- (void)setupViewPositions
{
    [self.bodyArea setThemePath:@"draft/body"];
    [self.topBackground setThemePath:@"draft/separators"];
    [self.fromBackground setThemePath:@"draft/body"];
    [self.toBackground setThemePath:@"draft/body"];
    [self.subjectBackground setThemePath:@"draft/body"];

    [self removeFocusRings];
    
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

    [self.bodyText setThemePath:@"draft/body"];

    [self.to setThemePath:@"draft/field"];
    [self.toLabel setThemePath:@"draft/fieldTitle"];
    
    [self.from setThemePath:@"draft/field"];
    [self.fromLabel setThemePath:@"draft/fieldTitle"];

    [self.subject setThemePath:@"draft/field"];
    [self.subjectLabel setThemePath:@"draft/fieldTitle"];
}

- (void)setupHighlightColors
{
    [self.to setSelectedThemePath:@"draft/fieldSelected"];
    [self.from setSelectedThemePath:@"draft/fieldSelected"];
    [self.subject setSelectedThemePath:@"draft/fieldSelected"];
    
    /*
    NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NavTheme.sharedNavTheme draftBodyTextSelectedColor], NSBackgroundColorAttributeName,
                         nil];
    NSTextView *tv;
    
    [self.to setSelectedThemePath:@"draft/fieldSelected"];
    [self.from setSelectedThemePath:@"draft/fieldSelected"];
    [self.subject setSelectedThemePath:@"draft/fieldSelected"];
    
    tv = (NSTextView *)[self.window fieldEditor:YES forObject:self.to];
    [tv setSelectedTextAttributes:att];
    
    tv = (NSTextView *)[self.window fieldEditor:YES forObject:self.from];
    [tv setSelectedTextAttributes:att];
    
    tv = (NSTextView *)[self.window fieldEditor:YES forObject:self.subject];
    [tv setSelectedTextAttributes:att];
     */
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSendButton) name:NSControlTextDidChangeNotification object:self.from];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSendButton) name:NSControlTextDidChangeNotification object:self.to];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSendButton) name:NSControlTextDidChangeNotification object:self.subject];
}

- (void)setBodyString:(NSString *)aString
{
    [self.bodyText insertText:aString];
    [self.bodyText setSelectedRange:NSMakeRange(0, 0)];
}

/*
 NSTextView * fieldEditor = [thePanel fieldEditor:NO forObject:theTextField];
 
 NSUInteger text_len = [[fieldEditor string] length];
 [fieldEditor setSelectedRange:(NSRange){text_len, 0}];
*/

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
    NSString *s = self.from.stringValue;
    NSString *address = [[BMClient sharedBMClient] addressForLabel:s];
    if (address) { s = address; }
    return s;
}

- (NSString *)toAddress
{
    NSString *s = self.to.stringValue;
    NSString *address = [[BMClient sharedBMClient] addressForLabel:s];
    if (address) { s = address; }
    return s;
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

- (void)open
{
    [self.from setNextKeyView:self.to];
    [self.to setNextKeyView:self.subject];
    [self.subject  setNextKeyView:self.bodyText];
    [self setAddressesToLabels];
    [self placeWindow];
    [self updateSendButton];
    [self.scrollView scrollToTop];
    [self.scrollView.window makeKeyAndOrderFront:nil];
}

- (void)close
{
    [self.window orderOut:self];
}

- (BOOL)windowShouldClose:(id)sender
{
    [[[self class] drafts] removeObject:self];

    //[[NSNotificationCenter defaultCenter] postNotificationName:@"draftClosed" object:self];
    return YES;
}

- (void)setCursorForReply
{
    NSInteger charIndex = 0;
    [self.bodyText setSelectedRange: NSMakeRange(charIndex, 0)];
    [self.scrollView becomeFirstResponder];
    //[self.bodyText becomeFirstResponder];
}

- (void)setCursorOnTo
{
    [self.to becomeFirstResponder];
}

// --- delegate ---

- (BOOL)hasValidAddresses
{
    return self.toCompletor.isValid && self.fromCompletor.isValid;
}

-(void)controlTextDidChange:(NSNotification *)note
{
    //NSLog(@"draft controlTextDidChange");

    NSTextField *field = [note object];
    NSString *address = [field.stringValue strip];
    
    if ([BMAddress isValidAddress:address])
    {
        [field setThemePath:@"draft/field"];
    }
    else
    {
        field.textColor = [NavTheme.sharedNavTheme formTextErrorColor];
    }
}

- (void)setDefaultFrom
{
    NSString *from = [[[[BMClient sharedBMClient] identities] firstIdentity] label];
    
    if (from)
    {
        [self.from setStringValue:from];
    }
}

- (void)setAddressesToLabels
{
    self.to.stringValue = [[BMClient sharedBMClient] labelForAddress:self.to.stringValue];
    self.from.stringValue = [[BMClient sharedBMClient] labelForAddress:self.from.stringValue];
}

- (void)addSubjectPrefix:(NSString *)prefix
{
    NSString *subject = self.subject.stringValue;
    
    if (![subject.lowercaseString hasPrefix:prefix.lowercaseString])
    {
        self.subject.stringValue = [prefix stringByAppendingString:subject];
    }
}

@end
