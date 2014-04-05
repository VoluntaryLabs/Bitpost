//
//  NSMutableAttributedString+extra.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/10/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSMutableAttributedString+extra.h"
#import "NSString+BM.h"

@implementation NSMutableAttributedString (extra)

+ (NSMutableAttributedString *)attachmentStringForImage:(NSImage *)image
{
   NSTextAttachmentCell *cell = [[NSTextAttachmentCell alloc] init];
   [cell setImage:image];
   
   NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
   [attachment setAttachmentCell:cell];
   
   NSAttributedString *as = [NSAttributedString attributedStringWithAttachment:attachment];
   
   NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
    
   return mas;
}

- (void)appendString:(NSString *)aString
{
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:aString attributes:nil];
    [self appendAttributedString:as];
}

+ (NSMutableAttributedString *)stringWithInlinedAttachmentsFromString:(NSString *)aString
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    // need to generalize this bit
    //NSString *startString = @"<img src=\"data:image/jpg;base64,";
    //NSString *startString = @"<attachment alt = \"mOnbTBG.jpg\" src='data:file/mOnbTBG.jpg;base64,";
    NSString *startString = @"base64,";
    
    NSString *endString = @"\'";

    while (YES)
    {
        // extract image
        // spliting isn't efficient, but simple and good enough for reasonably sized messages
        
        NSMutableArray *parts = [aString splitBetweenFirst:startString andString:endString];

        if (parts.count < 3)
        {
            [result appendString:parts.firstObject];
            break;
        }

        NSString *before = [parts objectAtIndex:0];
        NSString *middle = [parts objectAtIndex:1];
        NSString *after  = [parts objectAtIndex:2];

        NSData *data = middle.decodedBase64Data;
        //[data writeToFile:[@"~/test_image.jpg" stringByExpandingTildeInPath] atomically:YES];
        NSImage *image = [[NSImage alloc] initWithData:data];
        
        NSSize size = image.size;
        if (size.width > 300.0)
        {
            CGFloat scale = 300.0/size.width;
            size.width *= scale;
            size.height *= scale;
            image.size = size;
        }
        
        // attach image
        NSAttributedString *attachment = [NSMutableAttributedString attachmentStringForImage:image];
        
        [result appendString:before];
        [result appendAttributedString:attachment];

        aString = after;
    }

    return result;
}

@end
