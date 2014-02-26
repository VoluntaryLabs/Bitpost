//
//  AddressTextField.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/26/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//
// This is needed to get auto complete to behave properly

#import "AddressTextField.h"

@implementation AddressTextField

- (BOOL)eventIsDelete
{
    //return self.eventCharacter == NSDeleteCharacter;
    return self.eventCharacter == 127;
}

- (BOOL)eventIsSpace
{
    return self.eventCharacter == 32;
}

static NSEvent *keyEvent = nil;

- (void)resetEventCharacter
{
    self.eventCharacter = 0;
}

- (BOOL)becomeFirstResponder
{
    BOOL okToChange = [super becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidEndEditing:)
                                                 name:NSTextDidEndEditingNotification
                                               object:self];
    
    if (okToChange)
    {
        [self setKeyboardFocusRingNeedsDisplayInRect: [self bounds]];
        
        if (!keyEvent)
        {
            keyEvent =  [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
                
                NSString *characters = [event characters];
                unichar character = [characters characterAtIndex:0];
                self.eventCharacter = character;
                //NSLog(@"character = %i", (int)character);
                return event;
            } ];
            
        }
    }
    //NSLog(@"become first responder");
    return okToChange;
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    [NSEvent removeMonitor:keyEvent];
    keyEvent = nil;
    
    NSTextView *textView = [notification object];
    
    self.stringValue = textView.string;
}

@end
