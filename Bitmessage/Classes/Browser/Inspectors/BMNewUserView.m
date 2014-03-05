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
        self.darkColor = [NSColor colorWithCalibratedWhite:.3 alpha:1.0];
        self.mediumColor = [NSColor colorWithCalibratedWhite:.4 alpha:1.0];
        self.lightColor = [NSColor colorWithCalibratedWhite:1.0 alpha:1.0];
        
        [self setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin |
                                    NSViewHeightSizable | NSViewMinXMargin | NSViewMaxXMargin];

        
        self.instructionsText = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 30)];
        [self addSubview:self.instructionsText];
        self.instructionsText.string = @"Please choose a username and hit return to begin.";
        [self.instructionsText setupForDisplay];
        self.instructionsText.textColor = self.darkColor;

    
        self.instructionsText2 = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 30)];
        [self addSubview:self.instructionsText2];
        self.instructionsText2.string = @"";
        [self.instructionsText2 setupForDisplay];
        self.instructionsText2.textColor = self.darkColor;
        
        self.usernameField = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 30)];
        [self addSubview:self.usernameField];
        self.usernameField.string = @"Enter Username";
        [self.usernameField setupForEditing];
        [self.usernameField setDelegate:self];
        self.usernameField.textColor = self.lightColor;

        
        self.addressText = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, 30)];
        [self addSubview:self.addressText];
        self.addressText.string = @"";
        [self.addressText setupForEditing];
        [self.addressText setSelectable:NO];
        [self.addressText setEditable:NO];
        [self.addressText setFontSize:self.addressText.font.pointSize - 2];
        self.addressText.textColor = self.lightColor;

        [self layout];
    }
    
    return self;
}


- (void)layout
{
    CGFloat margin = 15.0;
    
    [self.usernameField centerXInSuperview];
    [self.usernameField centerYInSuperview];
    [self.usernameField setY:self.usernameField.y + 115.0];
    
    [self.instructionsText centerXInSuperview];
    [self.instructionsText placeYBelow:self.usernameField margin:margin];
    
    [self.addressText centerXInSuperview];
    [self.addressText placeYBelow:self.instructionsText margin:5];
    
    [self.instructionsText2 placeYBelow:self.addressText margin:margin];
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
    self.usernameField.string = self.identity.label;
}

- (void)saveName
{
    BMIdentity *identity = self.identity;
    identity.label = [self.usernameField.string strip];
    [identity update];
    [self showAddress];
}

- (void)showAddress
{
    [self.addressText setSelectable:YES];
    self.addressText.string = self.identity.address;
    self.instructionsText.string = @"Your generated bitmessage address is";
    self.instructionsText2.string = @"Like an email address, you can share this address to receive messages."; //\nYou can find this later and change your username in the My Identities tab.";
    [self addOkButton];
}

- (void)addOkButton
{
    self.okButton = [[BMButton alloc] initWithFrame:NSMakeRect(0, 0, self.width, 30)];
    [self.okButton setTarget:self];
    [self.okButton setActionTitle:@"OK"];
    [self.okButton setAction:@selector(ok)];
    [self.okButton setFontSize:22];
    [self.okButton updateTitle];
    [self addSubview:self.okButton];
    [self.okButton centerXInSuperview];
    [self.okButton placeYBelow:self.instructionsText2 margin:15.0];
}

- (void)ok
{
    [self close];
}

- (void)close
{
    self.replacementView.frame = self.frame;
    [self.window.contentView addSubview:self.replacementView];
    [self removeFromSuperview];
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

@end
