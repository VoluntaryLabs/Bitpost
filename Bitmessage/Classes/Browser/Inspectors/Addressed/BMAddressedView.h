//
//  BMAddressedView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NavView.h"

@interface BMAddressedView : NSView <NSTextViewDelegate>

@property (assign, nonatomic) id navView;
@property (assign, nonatomic) id <NavNode> node; // node keeps a ref to us?

@property (strong, nonatomic) NSTextView *labelField;
@property (strong, nonatomic) NSTextView *addressField;

@property (assign, nonatomic) BOOL isUpdating;

- (void)setup;

- (BOOL)isSynced;
- (void)syncToNode;
- (void)syncFromNode;

- (void)selectFirstResponder;

@end