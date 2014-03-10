//
//  NSMutableAttributedString+extra.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/10/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (extra)

+ (NSMutableAttributedString *)attachmentStringForImage:(NSImage *)image;

+ (NSMutableAttributedString *)stringWithInlinedAttachmentsFromString:(NSString *)aString;

- (void)appendString:(NSString *)aString;

@end
