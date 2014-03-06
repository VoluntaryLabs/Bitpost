//
//  BMNewUserView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMAddressedView.h"
#import "BMTextView.h"
#import "BMButton.h"

@interface BMNewUserView : NSView <NSTextViewDelegate, NSWindowDelegate>

@property (strong, nonatomic) BMTextView *instructionsText;
@property (strong, nonatomic) BMTextView *usernameField;
@property (strong, nonatomic) NSView *replacementView;
@property (strong, nonatomic) BMTextView *addressText;
@property (strong, nonatomic) BMTextView *instructionsText2;
@property (strong, nonatomic) BMButton *okButton;

@property (strong, nonatomic) NSColor *darkColor;
@property (strong, nonatomic) NSColor *mediumColor;
@property (strong, nonatomic) NSColor *lightColor;

- (void)open;

@end

