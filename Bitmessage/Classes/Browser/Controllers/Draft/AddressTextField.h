//
//  AddressTextField.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/26/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddressTextField : NSTextField

@property (assign, nonatomic) unichar eventCharacter;

- (BOOL)eventIsSpace;
- (BOOL)eventIsDelete;
- (BOOL)eventIsTab;

- (void)resetEventCharacter;

@end
