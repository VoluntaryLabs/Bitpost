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

- (NSColor *)selectedBgColor;
- (NSColor *)unselectedBgColor;

@end
