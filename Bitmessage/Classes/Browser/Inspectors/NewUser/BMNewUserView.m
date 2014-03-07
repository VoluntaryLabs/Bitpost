//
//  BMNewUserView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNewUserView.h"
#import "NSView+sizing.h"
#import "NSString+BM.h"
#import "BMClient.h"

@implementation BMNewUserView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.darkColor   = [NSColor colorWithCalibratedWhite:.45 alpha:1.0];
        self.mediumColor = [NSColor colorWithCalibratedWhite:.66 alpha:1.0];
        self.lightColor  = [NSColor colorWithCalibratedWhite:1.0 alpha:1.0];
        
        [self setAutoresizingMask:  NSViewWidthSizable |
                                    NSViewMinYMargin |
                                    NSViewMaxYMargin |
                                    NSViewHeightSizable |
                                    NSViewMinXMargin |
                                    NSViewMaxXMargin];

        
        self.instructionsText = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 50)];
        self.instructionsText.string = @"Please choose a username and hit return to begin.";
        [self.instructionsText setupForDisplay];
        self.instructionsText.textColor = self.darkColor;
        self.instructionsText.string = @"Looks like this is your first time running a bitmessage client\nso I've generated an address for you:";
    
        
        self.addressText = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 40)];
        self.addressText.string = self.identity.address;
        [self.addressText setupForEditing];
        [self.addressText setSelectable:YES];
        [self.addressText setEditable:NO];
        [self.addressText setFontSize:self.addressText.font.pointSize - 2];
        self.addressText.textColor = self.mediumColor;
        
        self.instructionsText2 = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 40)];
        self.instructionsText2.string = @"";
        [self.instructionsText2 setupForDisplay];
        self.instructionsText2.textColor = self.darkColor;
        self.instructionsText2.string = @"Like an email address, you can share this address to receive messages.\nYou can find this later in the My Identities tab.";
        
        self.okButton = [[BMButton alloc] initWithFrame:NSMakeRect(0, 0, self.width, 30)];
        //self.okButton = [[BMButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
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

- (void)windowDidResize:(NSNotification *)notification
{
    [self layout];
}

- (void)layout
{
    /*
    CGFloat margin = 15.0;
    
    [self.addressText centerXInSuperview];
    [self.addressText centerYInSuperview];

    [self.instructionsText centerXInSuperview];
    [self.instructionsText placeYAbove:self.addressText margin:margin];
    
    [self.instructionsText2 placeYBelow:self.addressText margin:margin];
    [self.okButton placeYBelow:self.instructionsText2 margin:margin];
    */
    //[self.okButton setWidth:100];
    [self stackSubviewsTopToBottomWithMargin:25.0];
    [self centerStackedSubviewsY];
    [self centerSubviewsX];
    //[self.okButton centerXInSuperview];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [[NSColor colorWithCalibratedWhite:0.1 alpha:1.0] set];
    [NSBezierPath fillRect:dirtyRect];
}

- (BMIdentity *)identity
{
    return [[[BMClient sharedBMClient] identities] createFirstIdentityIfAbsent];
}

- (void)open
{
    self.frame = self.replacementView.frame;
    [self.replacementView.superview addSubview:self];
    [self.replacementView removeFromSuperview];

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
    //NSLog(@"close!");
    
    for (NSView *view in self.subviews)
    {
        //[view animateDownFadeOut];
        [view animateFadeOut];
    }
    
    [self performSelector:@selector(completeClose) withObject:nil afterDelay:1.0];
}

- (void)completeClose
{
    self.replacementView.frame = self.frame;
    self.replacementView.alphaValue = 0.0;
    [self.window.contentView addSubview:self.replacementView];
    [self removeFromSuperview];
    [self.replacementView animateFadeIn];
}

/*
 - (void)saveName
 {
 [self.identity update];
 [self close];
 }
 
- (void)textDidChange:(NSNotification *)aNotification
{
    //NSLog(@"textDidChange: '%@'", self.usernameField.string);
    
    if ([self.usernameField.string containsString:@"\n"])
    {
        [self.usernameField setEditable:NO];
        [self.usernameField setSelectable:NO];
        self.usernameField.textColor = self.darkColor;
        
        self.usernameField.string = [self.usernameField.string
                                     stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        self.usernameField.string = self.usernameField.string.strip;
        [self saveName];
    }
}

- (void)textDidEndEditing:(NSNotification *)aNotification // needed?
{
    //NSLog(@"textDidEndEditing");
    [[aNotification object] endEditing];
}
*/

@end
