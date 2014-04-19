//
//  BMNewUserView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddressedView.h"
#import <NavKit/NavKit.h>

@interface BMNewUserView : NavColoredView <NSWindowDelegate>

@property (strong, nonatomic) NavTextView *instructionsText;
//@property (strong, nonatomic) NavTextView *usernameField;
@property (strong, nonatomic) NSView *replacementView;
@property (strong, nonatomic) NavTextView *addressText;
@property (strong, nonatomic) NavTextView *instructionsText2;
@property (strong, nonatomic) NavButton *okButton;

@property (strong, nonatomic) NSColor *darkColor;
@property (strong, nonatomic) NSColor *mediumColor;
@property (strong, nonatomic) NSColor *lightColor;

- (void)open;

@end

