//
//  BMMessageView.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>

@interface BMMessageView : ColoredView <NSTextViewDelegate>

@property (assign, nonatomic) id navView;
@property (strong, nonatomic) id <NavNode> node; // node keeps a ref to us?

@property (strong, nonatomic) NSScrollView *scrollView;
@property (strong, nonatomic) NSTextView *textView;

- (NSString *)selectedContent;

@end
