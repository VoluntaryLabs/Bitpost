//
//  BMContactView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NavView.h"

@interface BMContactView : NSView <NSTextFieldDelegate>

@property (assign, nonatomic) id navView;
@property (assign, nonatomic) id <NavNode> node; // node keeps a ref to us?

@property (strong, nonatomic) NSTextField *labelField;
@property (strong, nonatomic) NSTextField *addressField;

@property (assign, nonatomic) BOOL isUpdating;

@end
