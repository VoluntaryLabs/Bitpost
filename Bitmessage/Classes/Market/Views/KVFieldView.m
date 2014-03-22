//
//  KVFieldView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "KVFieldView.h"
#import "NSView+sizing.h"

@implementation KVFieldView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.keyText = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, 100, 20)];
        [self.keyText setupForDisplay];
        [self addSubview:self.keyText];
        self.keyWidth = 100;
        
        self.valueText = [[BMTextView alloc] initWithFrame:NSMakeRect(0, 0, 100, 20)];
        [self.keyText setupForEditing];
        [self addSubview:self.valueText];
        self.valueWidth = 100;
    }
    
    return self;
}

- (void)layout
{
    [self.keyText setWidth:self.keyWidth];
    [self.keyText setHeight:self.height];
    [self.keyText setX:0];
    
    [self.valueText setWidth:self.valueWidth];
    [self.valueText setHeight:self.height];
    [self.valueText setX:0];
    
    [self stackSubviewsLeftToRightWithMargin:10.0];
    [self setWidth:self.valueText.maxX];
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
