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

@end

