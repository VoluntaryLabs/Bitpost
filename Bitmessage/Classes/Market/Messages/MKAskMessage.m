//
//  MKAskMessage.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/20/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKAskMessage.h"


@implementation MKAskMessage

/*
{
     header:
     {
         service: "bitmarket",
         version: "1.0",
         type: "AskMessage"
     },
     
     body:
     {
         uuid: "XXX",
         region: ["country"],
         category: ["pathComponent0", "pathComponent1", ...],
         title: "",
         description: "",
         quantity: { number: 0.0 , unit: "[n/a, length, area, volume, mass]" },
         price: { number: 0.0, unit: "BTC" },
         shippingFrom: ["CountryCode1", "CountryCode2"],
         shippingToCountries: ["CountryCode1", "CountryCode2"],
         expirationDate: "...",
     }
}
*/

- (void)setDict:(NSDictionary *)dict
{
    // add validity check code
    
    NSDictionary *body  = [dict objectForKey:@"body"];
    
    self.category       = [body objectForKey:@"category"];
    self.title          = [body objectForKey:@"title"];
    self.description    = [body objectForKey:@"description"];
    
    self.quanityNumber  = [body objectForKey:@"quanityNumber"];
    self.quanityUnit    = [body objectForKey:@"quanityUnit"];
    
    self.priceNumber    = [body objectForKey:@"priceNumber"];
    self.priceCurrency  = [body objectForKey:@"priceCurrency"];
}

- (NSMutableDictionary *)dict
{
    // add validity check code
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    
    [dict setObject:self.standardHeader forKey:@"header"];
    [dict setObject:bodyDict forKey:@"body"];
    
    [bodyDict setObject:self.category forKey:@"category"];
    [bodyDict setObject:self.title forKey:@"title"];
    [bodyDict setObject:self.description forKey:@"description"];
    
    [bodyDict setObject:self.quanityNumber forKey:@"quanityNumber"];
    [bodyDict setObject:self.quanityUnit forKey:@"quanityUnit"];
    
    [bodyDict setObject:self.quanityNumber forKey:@"priceNumber"];
    [bodyDict setObject:self.quanityUnit forKey:@"priceCurrency"];
    
    return dict;
}

- (void)post
{
    
    
}


@end
