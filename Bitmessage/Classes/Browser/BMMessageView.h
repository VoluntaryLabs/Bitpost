//
//  BMMessageView.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NavView.h"

@interface BMMessageView : NSView

@property (assign, nonatomic) id navView;
@property (assign, nonatomic) id <NavNode> node; // node keeps a ref to us?

@property (strong, nonatomic) NSScrollView *scrollView;
@property (strong, nonatomic) NSView *marginView;
@property (strong, nonatomic) NSTextView *textView;
@property (assign, nonatomic) CGFloat margin;

@end
