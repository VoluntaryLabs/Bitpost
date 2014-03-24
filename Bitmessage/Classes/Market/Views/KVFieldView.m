//
//  KVFieldView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "KVFieldView.h"
#import "NSView+sizing.h"
#import "Theme.h"

@implementation KVFieldView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    self.autoresizesSubviews = NO;
    self.height = 25;
    CGFloat w = 200;
    
    if (self)
    {
        self.keyText = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, w, self.height)];
        [self.keyText setupForDisplay];
        //[self.keyText setBackgroundColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.1]];
        //[self.keyText setDrawsBackground:YES];
        [self addSubview:self.keyText];
        self.keyText.font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:16.0];
        self.keyText.alignment = NSRightTextAlignment;
        
        self.valueText = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, w, self.height)];
        [self.valueText setupForEditing];
        [self.valueText setBackgroundColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.1]];
        [self.valueText setDrawsBackground:YES];
        [self addSubview:self.valueText];
        self.valueText.font = [NSFont fontWithName:[Theme.sharedTheme lightFontName] size:16.0];
        self.valueText.alignment = NSLeftTextAlignment;

        [self layout];
    }
    
    return self;
}

- (void)layout
{
    //[self.keyText setWidth:self.keyWidth];
    [self.keyText setHeight:self.height];
    [self.keyText setY:0];
    
    //[self.valueText setWidth:self.valueWidth];
    [self.valueText setHeight:self.height];
    [self.valueText setY:0];
    
    [self stackSubviewsLeftToRightWithMargin:10.0];
    
    //[self.keyText show];
    //[self.valueText show];
    
    [self setWidth:self.maxXOfSubviews];
    [self setHeight:self.maxYOfSubviews];
}

- (void)setKey:(NSString *)key
{
    self.keyText.string = key;
}

- (void)setValue:(NSString *)value
{
    self.valueText.string = value;
}

- (void)textDidChange:(NSNotification *)aNotification
{
    if (!self.isUpdating) // to avoid textDidChange call from endEditingOnReturn
    {
        self.isUpdating = YES;
        
        @try
        {
            /*
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
             */
            
            //[self.addressField endEditingOnReturn];
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

- (void)textDidEndEditing:(NSNotification *)aNotification
{
    [[aNotification object] endEditing];
    //[self saveChanges];
}


@end
