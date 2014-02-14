//
//  NSString+extras.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSString+BM.h"

@implementation NSString (base64)

- (NSString *)encodedBase64
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [plainData base64EncodedStringWithOptions:0];
}

- (NSString *)decodedBase64
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    if (!data)
    {
        //NSLog(@"warning: attempt to decode base 64 with unknown characters");

        data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    
    if (!data)
    {
        NSLog(@"warning: failed to decode base 64 string");
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BOOL)containsString:(NSString *)other
{
    NSRange r = [self rangeOfString:other];
    return (r.location != NSNotFound);
}


- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (location; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (length; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]])
        {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingLeadingWhitespace
{
    return [self stringByTrimmingLeadingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingTrailingWhitespace
{
    return [self stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingLeadingWhitespaceAndNewline
{
    return [self stringByTrimmingLeadingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewline
{
    return [self stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)strip
{
    return [[self stringByTrimmingLeadingWhitespaceAndNewline] stringByTrimmingTrailingWhitespaceAndNewline];
}


@end

