//
//  BMAddressedView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NavView.h"
#import "MKSell.h"
#import "BMDictView.h"

@interface MKSellView : NSView <NSTextViewDelegate>

@property (assign, nonatomic) NavView *navView;
@property (assign, nonatomic) id <NavNode> node;

@property (strong, nonatomic) BMDictView *dictView;

@property (assign, nonatomic) BOOL isUpdating;

- (MKSell *)sell;

- (void)prepareToDisplay;
- (void)selectFirstResponder;

@end
