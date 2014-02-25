//
//  NSEvent+keys.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/19/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSEvent (keys)

- (BOOL)isDeleteDown;

- (BOOL)isLeftArrow;
- (BOOL)isRightArrow;
- (BOOL)isUpArrow;
- (BOOL)isDownArrow;

@end
