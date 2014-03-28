//
//  NSColor+array.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/14/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (array)

+ (NSColor *)colorWithObject:(id)anObject;

+ (NSColor *)withArray:(NSArray *)array;

@end
