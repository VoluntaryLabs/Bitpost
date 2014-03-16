//
//  ThemeDictionary.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/14/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeDictionary : NSObject

@property (strong) NSDictionary *dict;

+ (ThemeDictionary *)withDict:(NSDictionary *)dict;

- (NSColor *)columnBgColor;

- (NSColor *)unreadTextColor;
- (NSColor *)readTextColor;

- (NSColor *)textActiveColor;
- (NSColor *)textInactiveColor;

- (NSColor *)bgActiveColor;
- (NSColor *)bgInactiveColor;

- (NSString *)activeFontName;

@end
