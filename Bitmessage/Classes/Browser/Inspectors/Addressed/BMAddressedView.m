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
#import "BMContact.h"

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
    self.labelField.backgroundColor = [NSColor clearColor];
    self.labelField.textColor = [NSColor whiteColor];
    self.labelField.font = [NSFont fontWithName:@"Open Sans Light" size:24.0];
    [self.labelField centerXInSuperview];
    [self.labelField centerYInSuperview];
    [self.labelField setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self.labelField setAlignment:NSCenterTextAlignment];
    [self.labelField setDelegate:self];
    [self.labelField setRichText:NO];
    
    [self.labelField setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSColor colorWithCalibratedWhite:.3 alpha:1.0], NSBackgroundColorAttributeName,
      [NSColor whiteColor], NSForegroundColorAttributeName,
      nil]];
    
    
    self.addressField = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, self.width/2, 30)];
    [self addSubview:self.addressField];
    self.addressField.backgroundColor = [NSColor clearColor];
    self.addressField.textColor = [NSColor colorWithCalibratedWhite:.5 alpha:1.0];
    self.addressField.font = [NSFont fontWithName:@"Open Sans Light" size:16.0];
    [self.addressField centerXInSuperview];
    [self.addressField setY:self.labelField.maxY + 10];
    [self.addressField setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self.addressField setAlignment:NSCenterTextAlignment];
    [self.addressField setDelegate:self];
    [self.addressField setRichText:NO];
    
    [self.addressField setSelectedTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSColor colorWithCalibratedWhite:.3 alpha:1.0], NSBackgroundColorAttributeName,
      [NSColor whiteColor], NSForegroundColorAttributeName,
      nil]];
    
    [self.labelField setFocusRingType:NSFocusRingTypeNone];
    [self.addressField setFocusRingType:NSFocusRingTypeNone];
    
    [(NSTextView *)self.labelField setInsertionPointColor:[NSColor whiteColor]];
    [(NSTextView *)self.addressField setInsertionPointColor:[NSColor whiteColor]];
    
}

- (void)prepareToDisplay
{
    if ([self.labelField.string isEqualToString:[BMAddressed defaultLabel]])
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
}

- (void)setNode:(id <NavNode>)node
{
    _node = node;
    [self syncFromNode];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    NSColor *bgColor = [Theme objectForKey:@"BMContact-bgColorActive"];
    [bgColor set];
    [NSBezierPath fillRect:dirtyRect];
}

- (void)updateAddressColor
{
    self.contact.address = self.addressField.string;
    
    if (self.contact.isValidAddress)
    {
        self.addressField.textColor = [NSColor colorWithCalibratedWhite:.5 alpha:1.0];
    }
    else
    {
        self.addressField.textColor = [NSColor redColor];
    }
}

- (BMContact *)contact
{
    return (BMContact *)self.node;
}

// --- text changes ---

- (void)textDidChange:(NSNotification *)aNotification
{
    if (self.contact.canLiveUpdate)
    {
        [self update];
    }
    else
    {
        if (!self.isUpdating) // still needed?
        {
            self.isUpdating = YES;
            [self.labelField endEditingOnReturn];
            [self.addressField endEditingOnReturn];
            self.isUpdating = NO;
        }
    }
}

- (void)update
{
    if (!self.isUpdating) // still needed?
    {
        self.isUpdating = YES;
        
        // if return removed some text, we may need to commit it
        
        [self.labelField endEditingOnReturn];
        [self.addressField endEditingOnReturn];
        
        [self updateAddressColor];
        
        if (!self.isSynced)
        {
            [self syncToNode];
            
            if (self.contact.isValidAddress)
            {
                [self.contact update];
            }
        }
        
        self.isUpdating = NO;
    }
}

- (void)textDidEndEditing:(NSNotification *)aNotification
{
    [[aNotification object] endEditing];
    [self update];
}

// -- sync ----

- (BOOL)isSynced
{
    return [self.contact.visibleLabel isEqualToString:[self.labelField.string strip]] &&
    [self.contact.address isEqualToString:[self.addressField.string strip]];
}

- (void)syncToNode
{
    self.contact.visibleLabel   = [self.labelField.string strip];
    self.contact.address = [self.addressField.string strip];
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
//    [labelField becomeFirstResponder];
}


@end
