//
//  BMAddressedView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddressedView.h"
#import "NSTextView+extra.h"
#import "NSView+sizing.h"
#import "Theme.h"
#import "BMClient.h"

@implementation BMAddressedView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        [self setup];
    }
    
    return self;
}


- (void)setup
{
    //NSColor *textColor = [Theme objectForKey:@"BMContact-textColor"];
    //NSColor *bgColor   = [Theme objectForKey:@"BMContact-bgColorActive"];
    
    
    self.labelField   = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, self.width/2, 40)];
    [self addSubview:self.labelField];
    [self.labelField setDrawsBackground:NO];
    self.labelField.textColor = [Theme.sharedTheme formText1Color];
    self.labelField.font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:24.0];
    [self.labelField centerXInSuperview];
    [self.labelField centerYInSuperview];
    [self.labelField setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self.labelField setAlignment:NSCenterTextAlignment];
    [self.labelField setDelegate:self];
    [self.labelField setRichText:NO];
    
    [self.labelField setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [Theme.sharedTheme formTextSelectedBgColor], NSBackgroundColorAttributeName,
      //[Theme.sharedTheme formText1Color], NSForegroundColorAttributeName,
      nil]];
    
    
    self.addressField = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, self.width/2, 30)];
    [self addSubview:self.addressField];
    [self.addressField setDrawsBackground:NO];
    self.addressField.textColor = [Theme.sharedTheme formText2Color];
    self.addressField.font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:16.0];
    [self.addressField centerXInSuperview];
    [self.addressField setY:self.labelField.maxY + 10];
    [self.addressField setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self.addressField setAlignment:NSCenterTextAlignment];
    [self.addressField setDelegate:self];
    [self.addressField setRichText:NO];
    
    [self.addressField setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [Theme.sharedTheme formTextSelectedBgColor], NSBackgroundColorAttributeName,
      //[Theme.sharedTheme formText1Color], NSForegroundColorAttributeName,
      nil]];
    
    [self.labelField setFocusRingType:NSFocusRingTypeNone];
    [self.addressField setFocusRingType:NSFocusRingTypeNone];
    
    [(NSTextView *)self.labelField setInsertionPointColor:[Theme.sharedTheme formTextCursorColor]];
    [(NSTextView *)self.addressField setInsertionPointColor:[Theme.sharedTheme formTextCursorColor]];
    
    self.checkbox = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 30, 30)];
    [self.checkbox setImage:nil];
    [self addSubview:self.checkbox];
    
}

- (void)prepareToDisplay
{
    if ([self.labelField.string isEqualToString:[[self.node class] defaultLabel]])
    {        
        [self.window makeFirstResponder:self.labelField];
        //[self.labelField becomeFirstResponder];
        [self.labelField selectAll:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self setPositions];
}

- (void)setPositions
{
    [self.labelField centerXInSuperview];
    [self.labelField centerYInSuperview];
    [self.labelField setY:self.labelField.y + 40];
    
    [self.addressField centerXInSuperview];
    [self.addressField centerYInSuperview];
    [self.addressField setY:self.addressField.y - 0];
    
    [self.checkbox centerXInSuperview];
    [self.checkbox placeYBelow:self.addressField margin:30];
}

- (void)setNode:(id <NavNode>)node
{
    _node = node;
    [self syncFromNode];
    [self updateCheckbox];
    [self updateAddressColor];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    NSColor *bgColor = [Theme.sharedTheme formBackgroundColor];
    [bgColor set];
    [NSBezierPath fillRect:dirtyRect];
}

- (BOOL)hasValidAddress
{
    return [BMAddress isValidAddress:self.addressField.string.strip];
}

- (void)updateAddressColor
{
    if (self.hasValidAddress)
    {
        self.addressField.textColor = [Theme.sharedTheme formText2Color];
    }
    else
    {
        self.addressField.textColor = [Theme.sharedTheme formTextErrorColor];
    }
}

- (BMContact *)contact
{
    return (BMContact *)self.node;
}

// --- text changes ---

- (void)textDidChange:(NSNotification *)aNotification
{
    if (!self.isUpdating) // to avoid textDidChange call from endEditingOnReturn
    {
        self.isUpdating = YES;
        
        @try
        {
            if ([self.labelField didTab])
            {
                [self.window makeFirstResponder:[self.labelField nextKeyView]];
                self.isUpdating = NO;
                return;
            }
            
            [self.labelField endEditingOnReturn];
            [self.addressField endEditingOnReturn];
            [self updateAddressColor];
            [self updateCheckbox];
        }
        @catch (NSException *exception)
        {
            NSLog(@"exception %@", exception);
        }
        @finally
        {
            self.isUpdating = NO;
        }
    }
}

- (void)updateCheckbox
{
    if (!self.isUpdating && self.isSynced && self.contact.isSynced && self.hasValidAddress)
    {
        [self.checkbox setImage:[NSImage imageNamed:@"icon_tick"]];
    }
    else
    {
        [self.checkbox setImage:nil];
    }
    
    [self.checkbox display];
}

- (void)textDidEndEditing:(NSNotification *)aNotification
{
    NSLog(@"textDidEndEditing");
    [[aNotification object] endEditing];
    [self saveChanges];
}

- (void)saveChanges
{
    [self updateCheckbox];
    [self updateAddressColor];
    
    //if (!self.isSynced)
    {
        [self syncToNode];
        
        if (self.contact.isValidAddress)
        {
            [self.contact update];
        }
    }
    
    [self updateCheckbox];
    [self updateAddressColor];
}

// -- sync ----

- (BOOL)isSynced
{
    BOOL labelMatches = [self.contact.visibleLabel isEqualToString:self.labelField.string.strip];
    BOOL addressMatches = [self.contact.address isEqualToString:self.addressField.string.strip];
    
    return labelMatches && addressMatches;
}

- (void)syncToNode
{
    self.contact.visibleLabel   = [self.labelField.string strip];
    self.contact.address        = [self.addressField.string strip];
}

- (void)syncFromNode
{
    [self.labelField setString:self.contact.visibleLabel];
    [self.addressField setString:self.contact.address];
}

- (void)selectFirstResponder
{
    [self.window makeFirstResponder:self.labelField];
    [self.labelField selectAll:nil];
    //[labelField becomeFirstResponder];
}

@end
