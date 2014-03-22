//
//  BMTextView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/4/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMTextView.h"
#import "Theme.h"

@implementation BMTextView

- (BOOL)isOpaque
{
    return NO;
}

/*
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
    }

    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}
 */

- (void)setFontSize:(CGFloat)pointSize
{
    self.font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:pointSize];
}

- (void)setupForDisplay
{
    self.font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:16.0];
    self.textColor = [Theme.sharedTheme formText3Color];
    self.editable = NO;
    [self setAlignment:NSCenterTextAlignment];
    [self setRichText:NO];
    //[self setDrawsBackground:NO];
    [self setDrawsBackground:NO];
    
    [self setSelectable:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
}

- (void)setupForEditing
{
    self.font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:24.0];
    self.textColor = [Theme.sharedTheme formText1Color];
    self.editable = YES;
    [self setRichText:NO];
    //[self setDrawsBackground:NO];
    [self setDrawsBackground:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
    
    [self setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self setAlignment:NSCenterTextAlignment];
    [self setRichText:NO];
    [self setInsertionPointColor:[Theme.sharedTheme formTextCursorColor]];
    
    [self setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [Theme.sharedTheme formTextSelectedBgColor], NSBackgroundColorAttributeName,
      [Theme.sharedTheme formText1Color], NSForegroundColorAttributeName,
      nil]];
}

@end
