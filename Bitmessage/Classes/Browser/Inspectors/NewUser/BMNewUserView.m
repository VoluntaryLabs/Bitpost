//
//  BMNewUserView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNewUserView.h"
#import <NavKit/NavKit.h>
#import <BitMessageKit/BitMessageKit.h>

@implementation BMNewUserView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.darkColor   = [NavTheme.sharedNavTheme formText3Color];
        self.mediumColor = [NavTheme.sharedNavTheme formText2Color];
        self.lightColor  = [NavTheme.sharedNavTheme formText1Color];
        
        [self setAutoresizingMask:  NSViewWidthSizable |
                                    NSViewMinYMargin |
                                    NSViewMaxYMargin |
                                    NSViewHeightSizable |
                                    NSViewMinXMargin |
                                    NSViewMaxXMargin];

        
        self.instructionsText = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 50)];
        self.instructionsText.string = @"Please choose a username and hit return to begin.";
        [self.instructionsText setupForDisplay];
        self.instructionsText.textColor = self.darkColor;
        self.instructionsText.string = @"Looks like this is your first time running a bitmessage client\nso I've generated an address for you:";
    
        
        self.addressText = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 40)];
        self.addressText.string = self.identity.address;
        [self.addressText setupForEditing];
        [self.addressText setSelectable:YES];
        [self.addressText setEditable:NO];
        [self.addressText setFontSize:self.addressText.font.pointSize - 2];
        self.addressText.textColor = self.mediumColor;
        
        self.instructionsText2 = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 40)];
        self.instructionsText2.string = @"";
        [self.instructionsText2 setupForDisplay];
        self.instructionsText2.textColor = self.darkColor;
        self.instructionsText2.string = @"Like an email address, you can share this address to receive messages.\nYou can find this later in the My Identities tab.";
        
        self.okButton = [[NavButton alloc] initWithFrame:NSMakeRect(0, 0, self.width, 30)];
        //self.okButton = [[NavButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
        [self.okButton setTarget:self];
        [self.okButton setActionTitle:@"OK"];
        [self.okButton setAction:@selector(ok)];
        [self.okButton setFontSize:22];
        [self.okButton updateTitle];

        [self addSubview:self.instructionsText];
        [self addSubview:self.addressText];
        [self addSubview:self.instructionsText2];
        [self addSubview:self.okButton];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidResize:)
                                                     name:NSWindowDidResizeNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidResize:(NSNotification *)notification
{
    [self layout];
}

- (void)layout
{
    [self stackSubviewsTopToBottomWithMargin:25.0];
    [self centerStackedSubviewsY];
    [self centerSubviewsX];
    //[self.okButton centerXInSuperview];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [[NavTheme.sharedNavTheme formBackgroundColor] set];
    NSRectFill(dirtyRect);
}

- (BMIdentity *)identity
{
    return [[[BMClient sharedBMClient] identities] createFirstIdentityIfAbsent];
}

- (void)open
{
    NSView *contentView = self.targetWindow.contentView;
    self.frame = contentView.frame;
    //[self.window.contentView replaceSubview:self.replacementView with:self];

    [contentView addSubview:self];

    if (self.identity.hasUnsetLabel)
    {
        self.identity.label = NSFullUserName();
        [self.identity update];
    }

    [self layout];
    
    for (NSView *view in self.subviews)
    {
        [view animateUpFadeIn];
    }
}

- (void)ok
{
    [self close];
}

- (void)close
{    
    for (NSView *view in self.subviews)
    {
        //[view animateDownFadeOut];
        [view animateFadeOut];
    }
    
    [self performSelector:@selector(completeClose) withObject:nil afterDelay:1.0];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)completeClose
{
    //NSView *contentView = self.targetWindow.contentView;
    [self removeFromSuperview];
    
    //self.replacementView.alphaValue = 1.0;
    //[self.window.contentView replaceSubview:self with:self.replacementView];
    //[self.window.contentView addSubview:self  positioned:NSWindowAbove relativeTo:nil];

    //[self.window.contentView addSubview:self.replacementView];
    //[self removeFromSuperview];
    //[self.replacementView animateFadeIn];
}

@end
