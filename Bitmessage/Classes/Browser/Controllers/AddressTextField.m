//
//  AddressTextField.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/26/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "AddressTextField.h"

@implementation AddressTextField

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    return self;
}

- (void)keyDown:(NSEvent *)theEvent
{
    NSLog(@"keyDown %@", theEvent);
    
    [super keyDown:theEvent];
}

- (void)deleteBackward:(id)sender
{
    NSLog(@"deleteBackward");
}

@end
