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
    self.labelField   = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, self.width/2, 40)];
    [self addSubview:self.labelField];
    
    [self.labelField setDrawsBackground:NO];
    //[self.labelField setBackgroundColor:[NSColor colorWithCalibratedWhite:.3 alpha:1.0]];
    
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
    
    //[self.labelField setNextKeyView:self.addressField];
    //[self.addressField setNextKeyView:self.labelField];
    
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
    
    [self setPositions];
    
}

- (void)prepareToDisplay
{
    if ([self.labelField.string isEqualToString:[[self.node class] defaultLabel]])
    {        
        [self.window makeFirstResponder:self.labelField];
        //[self.labelField becomeFirstResponder];
        [self.labelField selectAll:nil];
    }
    [self setPositions];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self setPositions];
    //[self updateCheckbox];
    //[self updateAddressColor];
}

- (void)setPositions
{
    CGFloat h = self.labelField.superview.height;
    NSLog(@"h = %i", (int)h);
    
    [self.labelField centerXInSuperview];
    //[self.labelField centerYInSuperview];
    //[self.labelField setY:self.labelField.y + 40];
    [self.labelField setY:h/2 + 10];
    NSLog(@"self.labelField.y = %i", (int)self.labelField.y);
    
    [self.addressField centerXInSuperview];
    [self.addressField placeYBelow:self.labelField margin:30];
    
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
    //[self setPositions]; // don't like this here but couldn't find who was moving the label
	[super drawRect:dirtyRect];
    NSColor *bgColor = [Theme.sharedTheme formBackgroundColor];
    [bgColor set];
    NSRectFill(dirtyRect);
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
                [self.labelField removeTabs];
                
                NSTextView *next = (NSTextView *)[self.labelField nextKeyView];
                
                if (next && [next isEditable])
                {
                    [self.window makeFirstResponder:next];
                    [next selectAll:nil];
                }
                
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
    //NSLog(@"textDidEndEditing");
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
        [self updateContact];
        [self syncFromNode];
    }
    
    [self updateCheckbox];
    [self updateAddressColor];
    //[self setPositions];
}

- (void)updateContact
{
    if (self.contact.isValidAddress)
    {
        [self.contact update];
    }
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
