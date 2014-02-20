//
//  NSEvent+keys.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/19/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSEvent+keys.h"

@implementation NSEvent (keys)

- (BOOL)isDeleteDown
{
    if ([self type] == NSKeyDown)
    {
        NSString* pressedChars = [self characters];
        
        if ([pressedChars length] == 1)
        {
            unichar pressedUnichar =
            [pressedChars characterAtIndex:0];
            
            if ( (pressedUnichar == NSDeleteCharacter) ||
                (pressedUnichar == 0xf728) )
            {
                return YES;
            }
        }
    }
    return NO;
}

@end
