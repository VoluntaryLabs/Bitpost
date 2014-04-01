//
//  NSTextView+extra.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTextView (extra)

- (void)endEditing;

- (BOOL)didTab;
- (void)removeTabs;

- (BOOL)endEditingOnReturn;
- (void)removeReturns;

//- (void)setThemePath:(NSString *)aPath;

@end