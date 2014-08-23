//
//  BMAddressedView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "BMAddressedView.h"
#import <NavKit/NavKit.h>
#import <BitmessageKit/BitmessageKit.h>

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
    [self setThemePath:@"address/background"];

    self.innerView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, self.width, self.height)];
    [self addSubview:self.innerView];
    [_innerView setAutoresizesSubviews:NO];
    
    self.labelField   = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, self.width/2, 24)];
    [self.innerView addSubview:self.labelField];
    
    [self.labelField setThemePath:@"address/label"];
    [self.labelField setSelectedThemePath:@"address/selected"];

    [self.labelField centerXInSuperview];
    [self.labelField centerYInSuperview];
    [self.labelField setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self.labelField setDelegate:self];
    [self.labelField setRichText:NO];
    
    // address color is 143.0/255.0
    self.addressField = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, self.width/2, 16)];
    [self.innerView addSubview:self.addressField];
    
    [self.addressField setThemePath:@"address/address"];
    [self.addressField setSelectedThemePath:@"address/selected"];
    
    [self.addressField centerXInSuperview];
    [self.addressField setY:self.labelField.maxY + 10];
    [self.addressField setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self.addressField setDelegate:self];
    [self.addressField setRichText:NO];
    
    
    self.checkbox = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 30, 30)];
    [self.checkbox setImage:nil];
    [self.innerView addSubview:self.checkbox];
    
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
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self setPositions];
    [self setPositions];
}

- (void)setPositions
{
    //[self.innerView setFrame:self.bounds];
    [self.innerView setFrame:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];
    //[self.innerView centerXInSuperview];
    //[self.innerView centerYInSuperview];
    
    [self.labelField setX:0];
    [self.labelField setY:0];
    [self.labelField setWidth:self.width];
    
    [self.addressField setX:0];
    [self.addressField placeYBelow:_labelField margin:10];
    [self.addressField setWidth:self.width];
    
    [self.checkbox placeYBelow:_addressField margin:40];
    
    [self.innerView sizeAndRepositionSubviewsToFit];
    [self.innerView setWidth:self.width];
    //[self.innerView centerSubviewsX];
    [self.addressField centerXInSuperview];
    [self.checkbox centerXInSuperview];
    [self.innerView centerYInSuperview];
}

- (void)setNode:(NavNode *)node
{
    _node = node;
    [self syncFromNode];
    [self updateCheckbox];
    [self updateAddressColor];
}

// change to get from col
/*
- (void)drawRect:(NSRect)dirtyRect
{
    //[self setPositions]; // don't like this here but couldn't find who was moving the label
	[super drawRect:dirtyRect];

    [bgColor set];
    NSRectFill(dirtyRect);
}
*/

- (BOOL)hasValidAddress
{
    return [BMAddress isValidAddress:self.addressField.string.strip];
}

- (void)updateAddressColor
{
    if (self.hasValidAddress)
    {
        [self.addressField setThemePath:@"address/address"];
    }
    else
    {
        [self.addressField setThemePath:@"address/addressError"];

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
            
            if([self.labelField endEditingOnReturn])
            {
                [self saveChanges];
                [self.labelField gotoNext];
            }
            
            if([self.addressField endEditingOnReturn])
            {
                [self saveChanges];
                [self.labelField gotoNext];
            }
            
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
    if (/*!self.isUpdating &&*/ self.isSynced && self.contact.isSynced && self.hasValidAddress)
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
    
    [self.labelField display];
    [self.addressField display];
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
    BOOL labelMatches = [self.contact.visibleLabel
                         isEqualToString:self.labelField.string.strip];
    
    BOOL addressMatches = [self.contact.address
                           isEqualToString:self.addressField.string.strip];
    
    return labelMatches && addressMatches;
}

- (void)syncToNode
{
    self.contact.visibleLabel = [self.labelField.string strip];
    self.contact.address      = [self.addressField.string strip];
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
