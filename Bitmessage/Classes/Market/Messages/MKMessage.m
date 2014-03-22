//
//  MKMessage.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMessage.h"

@implementation MKMessage

+ (NSString *)serviceName
{
    return @"bitmarkets";
}

+ (NSString *)serviceVersion
{
    return @"1.0";
}

/*
{
    header:
    {
        service: "bitmarket",
        version: "1.0",
        type: "AskMessage"
    },
     ...
}
*/

- (NSMutableDictionary *)standardHeader
{
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setObject:@"bitmarket" forKey:@"service"];
    [header setObject:@"1.0" forKey:@"version"];
    return header;
}

+ (NSSet *)typeClassNames
{
    NSSet *names = [NSSet setWithObjects:
                    @"AskMessage",
                    @"BidMessage",
                    @"AcceptMessage",
                    @"DeliveryMessage",
                    @"CommentMessage",
                    @"RequestRefundMessage",
                    @"SentPaymentMessage",
                    nil];
    return names;
}

- (NSString *)nodeTitle
{
    return NSStringFromClass([self class]);
}

- (NSString *)nodeSubtitle
{
    //return self.date.description;
    return nil;
}


/*
 {
 header:
 {
 service: "bitmarket",
 version: "1.0",
 type: "AskMessage"
 },
 
 body: { ... }
 }
 */

+ (MKMessage *)withBMMessage:(BMMessage *)bmMessage
{
    if (![bmMessage.subjectString isEqualToString:@"bitmarkets"])
    {
        return nil;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithJsonString:bmMessage.messageString];
    if (!dict)
    {
        return nil;
    }
    
    // todo: make a MKMessageHeader class to handle this
    
    NSDictionary *header = [dict objectForKey:@"header"];
    if (!header || ![header isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    BOOL correctService = [[header objectForKey:@"service"] isEqualToString:self.serviceName];
    if (!correctService)
    {
        return nil;
    }
    
    BOOL supportedVersion = [[header objectForKey:@"version"] isEqualToString:self.serviceVersion];
    if (!supportedVersion)
    {
        return nil;
    }
    
    NSString *type = [header objectForKey:@"type"];
    if (!type || [self.typeClassNames member:type])
    {
        return nil;
    }
    
    Class msgClass = NSClassFromString([@"MK" stringByAppendingString:type]);
    if (!msgClass)
    {
        return nil;
    }
    
    MKMessage *instance = [[msgClass alloc] init];
    [instance setBmMessage:bmMessage];
    return instance;
}

- (void)setDict:(NSDictionary *)dict
{
    [NSException raise:@"Missing implementatio " format:@"subclasses should implement this method"];
}


@end
