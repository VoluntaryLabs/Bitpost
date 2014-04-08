//
//  NSString+BM.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/25/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (base64)

- (NSString *)encodedBase64;
- (NSString *)decodedBase64;
- (NSData *)decodedBase64Data;

- (BOOL)containsString:(NSString *)other;
- (BOOL)containsCaseInsensitiveString:(NSString *)other;

- (NSString *)stringByTrimmingLeadingWhitespace;
- (NSString *)stringByTrimmingTrailingWhitespace;
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewline;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewline;

- (NSString *)strip;
- (NSString *)stringWithReturnsRemoved;

- (NSRange)rangeBetweenString:(NSString *)startString andString:(NSString *)endString afterIndex:(NSUInteger)searchIndex;
- (NSMutableArray *)splitBetweenFirst:(NSString *)startString andString:(NSString *)endString;

- (NSString *)before:(NSString *)aString;
- (NSString *)after:(NSString *)aString;

@end
