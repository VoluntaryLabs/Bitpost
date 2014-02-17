//
//  BMContactView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NavView.h"

@interface BMContactView : NSView <NSTextViewDelegate>

@property (assign, nonatomic) id navView;
@property (assign, nonatomic) id <NavNode> node; // node keeps a ref to us?

@property (strong, nonatomic) NSTextView *labelField;
@property (strong, nonatomic) NSTextView *addressField;

@property (assign, nonatomic) BOOL isUpdating;

@end
