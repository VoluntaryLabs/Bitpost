//
//  InfoPanelController.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/18/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "InfoPanelController.h"
#import "NSView+sizing.h"
#import "InfoButton.h"
#import "ColoredView.h"
#import "Theme.h"

@implementation InfoPanelController

static InfoPanelController *shared = nil;

+ (InfoPanelController *)sharedInfoPanelController
{
    if (!shared)
    {
        shared = [[InfoPanelController alloc] initWithNibName:@"Info" bundle:nil];
    }
    
    return shared;
}

- (NSWindow *)window
{
    return self.view.window;
}

- (NSTextView *)infoText
{
    return (NSTextView *)self.view;
}

- (void)open
{
    [self.window makeKeyAndOrderFront:self];
    NSRect f = [[NSApplication sharedApplication] mainWindow].frame;
    NSPoint c = NSMakePoint(f.origin.x + f.size.width/2.0, f.origin.y + f.size.height/2.0);
    
    //[self setFrameOrigin:NSMakePoint(c.x - self.frame.width/2.0, x.y - self.frame.height/2.0)];
    
    [self.window center];
    [self.window setLevel:NSTornOffMenuWindowLevel];
    //[(ColoredView *)self.view setBackgroundColor:[NSColor colorWithCalibratedWhite:1.0 alpha:.05]];
}

- (void)pushHeader:(NSString *)aName
{
    id lastView = self.view.subviews.lastObject;
    CGFloat y = lastView ? 0 : self.view.height - 78;
    
    NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, y, self.view.width, 25)];
    [self.view addSubview:button];
    [button setTitle:aName];
    [button setButtonType:NSMomentaryChangeButton];
    //[button setEnabled:NO];
    [button setThemePath:@"info/header"];
    
    if (lastView)
    {
        [button placeYBelow:lastView margin:0];
    }
}

- (void)pushSubheader:(NSString *)aName
{
    id lastView = self.view.subviews.lastObject;
    
    NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, self.view.width, 25)];
    [self.view addSubview:button];
    [button setTitle:aName];
    [button setButtonType:NSMomentaryChangeButton];
    //[button setEnabled:NO];
    [button setThemePath:@"info/subheader"];
    
    if (lastView)
    {
        [button placeYBelow:lastView margin:0];
    }
}

- (void)pushTitle:(NSString *)normalTitle
{
    id lastView = self.view.subviews.lastObject;
    CGFloat y = lastView ? 0 : self.view.height - 80;
    
    InfoButton *button = [[InfoButton alloc] initWithFrame:NSMakeRect(0, y, self.view.width, 25)];
    [self.view addSubview:button];
    [button setTitle:normalTitle];
    [button setButtonType:NSMomentaryChangeButton];
    //[button setEnabled:NO];
    [button setThemePath:@"info/title"];
    
    if (lastView)
    {
        [button placeYBelow:lastView margin:30];
    }
}

- (void)pushItem:(NSString *)normalTitle altTitle:(NSString *)altTitle
{
    id lastView = self.view.subviews.lastObject;
    
    InfoButton *button = [[InfoButton alloc] initWithFrame:NSMakeRect(0, 0, self.view.width, 28)];
    [self.view addSubview:button];
    [button setTitle:normalTitle];
    [button setButtonType:NSMomentaryChangeButton];
    [button setThemePath:@"info/item"];
    button.normalTitle = normalTitle;
    button.altTitle = altTitle;
    button.titleThemePath = @"info/item";
    
    if (lastView)
    {
        [button placeYBelow:lastView margin:0];
    }
}

- (void)awakeFromNib
{
    [self.window setDelegate:self];
    
    [self.view setThemePath:@"info/background"];
    
    //[self pushHeader:@"Whisper"];
    //[self pushSubheader:@"a Bitmessage client"];
    
    //[self pushTitle:@"Whisper Bitmessage client"];
    [self pushHeader:@"Whisper"];
    [self pushSubheader:@"Bitmessage client"];
    [self pushItem:@"" altTitle:@""];

    
    //[self pushTitle:@"Design"];
    [self pushItem:@"Chris Robertson" altTitle:@"Design"];
    
    //[self pushTitle:@"Lead / UI"];
    [self pushItem:@"Steve Dekorte" altTitle:@"Lead / UI"];
    
    //[self pushTitle:@"Python Wrangler / Attachments"];
    [self pushItem:@"Adam Thorsen" altTitle:@"Python Wrangler / Attachments"];
    
    //[self pushTitle:@"Unix Guru"];
    [self pushItem:@"Dru Nelson" altTitle:@"Unix Guru"];

    [self.view centerSubviewsX];
    [self.view display];
}


- (void)close
{
    [self.window orderOut:self];
}

- (BOOL)windowShouldClose:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoClosed" object:self];
    return YES;
}

@end
