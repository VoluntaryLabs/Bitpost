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

- (NSColor *)activeTextColor
{
    return [self colorForKey:@"activeTextColor"];
}

- (NSColor *)inactiveTextColor
{
    return [self colorForKey:@"inactiveTextColor"];
}

// background

- (NSColor *)activeBgColor
{
    return [self colorForKey:@"activeBgColor"];
}

- (NSColor *)inactiveBgColor
{
    return [self colorForKey:@"inactiveBgColor"];
}

- (NSString *)activeFontName
{
    return [self.dict objectForKey:@"activeFontName"];
}


@end
