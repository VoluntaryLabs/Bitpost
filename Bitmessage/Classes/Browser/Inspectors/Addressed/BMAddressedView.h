//
//  BMAddressedView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>
#import <BitmessageKit/BMContact.h>

@interface BMAddressedView : ColoredView <NSTextViewDelegate>

@property (assign, nonatomic) id navView;
@property (assign, nonatomic) id <NavNode> node; // node keeps a ref to us?

@property (strong, nonatomic) NSView *innerView; // contains labels and checkbox
@property (strong, nonatomic) NSTextView *labelField;
@property (strong, nonatomic) NSTextView *addressField;
@property (strong, nonatomic) NSImageView *checkbox;

@property (assign, nonatomic) BOOL isUpdating;

- (BMContact *)contact;

- (void)setup;
- (void)prepareToDisplay;

- (BOOL)isSynced;
- (void)syncToNode;
- (void)syncFromNode;

- (void)selectFirstResponder;

@end
