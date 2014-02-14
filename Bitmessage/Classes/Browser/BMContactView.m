//
//  BMContactView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMContactView.h"
#import "NSView+sizing.h"
#import "Theme.h"
#import "BMContact.h"

@implementation BMContactView

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
    NSColor *textColor = [Theme objectForKey:@"BMContact-textColor"];
    NSColor *bgColor   = [Theme objectForKey:@"BMContact-bgColorActive"];
    
    
    self.labelField   = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, self.width/2, 40)];
    [self addSubview:self.labelField];
    self.labelField.backgroundColor = [NSColor clearColor];
    self.labelField.textColor = [NSColor whiteColor];
    self.labelField.font = [NSFont fontWithName:@"Open Sans Light" size:24.0];
    [self.labelField centerXInSuperview];
    [self.labelField centerYInSuperview];
    [self.labelField setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self.labelField setAlignment:NSCenterTextAlignment];
    [self.labelField setBordered:NO];
    [self.labelField setDelegate:self];
    
    
    self.addressField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, self.width/2, 30)];
    [self addSubview:self.addressField];
    self.addressField.backgroundColor = [NSColor clearColor];
    self.addressField.textColor = [NSColor colorWithCalibratedWhite:.5 alpha:1.0];
    self.addressField.font = [NSFont fontWithName:@"Open Sans Light" size:16.0];
    [self.addressField centerXInSuperview];
    [self.addressField setY:self.labelField.maxY + 10];
    [self.addressField setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin];
    [self.addressField setAlignment:NSCenterTextAlignment];
    [self.addressField setBordered:NO];
    [self.addressField setDelegate:self];
    
    [self.labelField setFocusRingType:NSFocusRingTypeNone];
    [self.addressField setFocusRingType:NSFocusRingTypeNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedText:) name:NSControlTextDidChangeNotification object:self.labelField];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedText:) name:NSControlTextDidChangeNotification object:self.addressField];
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
    
    BMContact *contact = (BMContact *)node;
    
    [self.labelField setStringValue:contact.label];
    [self.addressField setStringValue:contact.address];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    NSColor *bgColor = [Theme objectForKey:@"BMContact-bgColorActive"];
    [bgColor set];
    [NSBezierPath fillRect:dirtyRect];
}

- (void)updatedText:(NSNotification *)note
{
    NSLog(@"updatedText");
    //[(BMContact *)self.node update];
    [self.addressField setStringValue:[self.addressField.stringValue strip]];
    [self updateAddressColor];

}

- (void)updateAddressColor
{
    self.contact.address = self.addressField.stringValue;
    
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

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if (!self.isUpdating)
    {
        self.isUpdating = YES;
        NSLog(@"contact textShouldEndEditing");
                
        self.contact.label   = self.labelField.stringValue;
        self.contact.address = self.addressField.stringValue;
        
        if (self.contact.isValidAddress)
        {
            [self.contact update];
        }
        
        self.isUpdating = NO;
    }


    return YES;
}


@end



