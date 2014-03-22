//
//  MKSellView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSellView.h"
#import "NSTextView+extra.h"
#import "NSView+sizing.h"
#import "Theme.h"

@implementation MKSellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.dictView = [[BMDictView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
        [self addSubview:self.dictView];
        
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        
        NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
        [textDict setObject:@"value" forKey:@"key"];
        [self.dictView setDict:textDict];
    }
    
    return self;
}

- (void)prepareToDisplay
{
    [self layout];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)layout
{
    
}

- (void)setNode:(id <NavNode>)node
{
    _node = node;
}

- (MKSell *)sell
{
    return (MKSell *)self.node;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    //NSColor *bgColor = [Theme.sharedTheme formBackgroundColor];
    NSColor *bgColor = [NSColor redColor];
    [bgColor set];
    NSRectFill(dirtyRect);
}

/*
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
*/


- (void)textDidEndEditing:(NSNotification *)aNotification
{
    [[aNotification object] endEditing];
    [self saveChanges];
}

- (void)saveChanges
{

}

// -- sync ----

- (void)selectFirstResponder
{
    //[self.window makeFirstResponder:self.labelField];
    //[self.labelField selectAll:nil];
    //[labelField becomeFirstResponder];
}

@end
