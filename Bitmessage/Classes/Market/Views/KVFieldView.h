//
//  KVFieldView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BMTextView.h"

@interface KVFieldView : NSView

@property (strong, nonatomic) NSString *key;

@property (strong, nonatomic) BMTextView *keyText;
@property (strong, nonatomic) BMTextView *valueText;

//@property (assign, nonatomic) CGFloat keyWidth;
//@property (assign, nonatomic) CGFloat valueWidth;

@property (assign, nonatomic) BOOL isUpdating;

- (void)layout;

- (void)setKey:(NSString *)key;
- (void)setValue:(NSString *)value;

@end
