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
    NSData *data = self.decodedBase64Data;
    
    if (data)
    {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

- (NSData *)decodedBase64Data
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
    }
    
    return data;
}

- (BOOL)containsString:(NSString *)other
{
    NSRange r = [self rangeOfString:other];
    return (r.location != NSNotFound);
}

- (BOOL)containsCaseInsensitiveString:(NSString *)other
{
    return [self rangeOfString:other options:NSCaseInsensitiveSearch].location != NSNotFound;
}


- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (; location < length; location++)
    {
        if (![characterSet characterIsMember:charBuffer[location]])
        {
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
    
    for (; length > 0; length--)
    {
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

- (NSString *)stringWithReturnsRemoved
{
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}


- (NSRange)rangeBetweenString:(NSString *)startString andString:(NSString *)endString afterIndex:(NSUInteger)searchIndex
{
    NSRange startRange = [self rangeOfString:startString];
    
    if (startRange.location != NSNotFound)
    {
        NSInteger start = startRange.location + startRange.length;
        NSRange endRange = [self rangeOfString:endString options:0 range:NSMakeRange(start, self.length - start)];
        NSRange matchRange = NSMakeRange(start, endRange.location-start);
        return matchRange;
    }
    
    return NSMakeRange(NSNotFound, 0);
}

- (NSMutableArray *)splitBetweenFirst:(NSString *)startString andString:(NSString *)endString
{
    NSMutableArray *results = [NSMutableArray array];
    NSRange startRange = [self rangeOfString:startString
                                     options:NSLiteralSearch];
    
    if (startRange.location != NSNotFound)
    {
        NSInteger start = startRange.location + startRange.length;
        NSRange endRange = [self rangeOfString:endString
                                       options:NSLiteralSearch
                                         range:NSMakeRange(start, self.length - start)];
        
        if (endRange.location != NSNotFound)
        {
            NSRange matchRange = NSMakeRange(start, endRange.location-start);
            
            NSString *before = [self substringWithRange:NSMakeRange(0, startRange.location)];
            NSString *middle = [self substringWithRange:matchRange];
            
            NSInteger afterIndex = endRange.location + endRange.length;
            NSString *after = [self substringWithRange:NSMakeRange(afterIndex, self.length - afterIndex)];
            
            [results addObject:before];
            [results addObject:middle];
            [results addObject:after];
        }
        else
        {
            [results addObject:[NSString stringWithString:self]];
        }
    }
    else
    {
        [results addObject:[NSString stringWithString:self]];
    }
    
    return results;
}

- (NSString *)before:(NSString *)aString
{
    NSRange startRange = [self rangeOfString:aString options:NSLiteralSearch];
    
    if (startRange.location == NSNotFound)
    {
        return self;
    }
    
    NSString *before = [self substringWithRange:NSMakeRange(0, startRange.location)];
    return before;
}

- (NSString *)after:(NSString *)aString
{
    NSRange endRange = [self rangeOfString:aString options:NSLiteralSearch];
    
    if (endRange.location == NSNotFound)
    {
        return self;
    }
    
    NSInteger afterIndex = endRange.location + endRange.length;
    NSString *after = [self substringWithRange:NSMakeRange(afterIndex, self.length - afterIndex)];
    return after;
}

@end

