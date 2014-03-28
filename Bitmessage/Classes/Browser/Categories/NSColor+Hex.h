//
//  NSColor+Hex.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/28/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Hex)

- (NSString *)hexadecimalValue;
+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex;

@end
