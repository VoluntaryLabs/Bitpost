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
        [textDict setObject:@"title" forKey:@"title"];
        [textDict setObject:@"description" forKey:@"description"];
        [textDict setObject:@"quantity" forKey:@"quantity"];
        [textDict setObject:@"price" forKey:@"price"];
        //[textDict setObject:@"currency" forKey:@"BTC"];
        [self.dictView setDict:textDict];
    }
    
    return self;
}

- (void)setDict:(NSMutableDictionary *)dict
{
    [self.dictView setDict:dict];
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
    [_dictView layout];
    [_dictView centerXInSuperview];
    [_dictView centerYInSuperview];
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
    [[Theme.sharedTheme formBackgroundColor] set];
    //[[NSColor redColor] set];
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
