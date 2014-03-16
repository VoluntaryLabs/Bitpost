//
//  ThemeDictionary.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/14/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "ThemeDictionary.h"
#import "NSColor+array.h"

@implementation ThemeDictionary

+ (ThemeDictionary *)withDict:(NSDictionary *)dict;
{
    ThemeDictionary *t = [[ThemeDictionary alloc] init];
    t.dict = dict;
    return t;
}

- (NSColor *)colorForKey:(NSString *)k
{
    NSArray *colorArray = [self.dict objectForKey:k];
    return [NSColor withArray:colorArray];
}

// column

- (NSColor *)columnBgColor
{
    return [self colorForKey:@"columnBgColor"];
}

// read

- (NSColor *)unreadTextColor
{
    return [self colorForKey:@"unreadTextColor"];
}

- (NSColor *)readTextColor
{
    return [self colorForKey:@"readTextColor"];
}

// text

- (NSColor *)textActiveColor
{
    return [self colorForKey:@"textActiveColor"];
}

- (NSColor *)textInactiveColor
{
    return [self colorForKey:@"textInactiveColor"];
}

// background

- (NSColor *)bgActiveColor
{
    return [self colorForKey:@"bgActiveColor"];
}

- (NSColor *)bgInactiveColor
{
    return [self colorForKey:@"bgInactiveColor"];
}

- (NSString *)activeFontName
{
    return [self.dict objectForKey:@"activeFontName"];
}


@end
