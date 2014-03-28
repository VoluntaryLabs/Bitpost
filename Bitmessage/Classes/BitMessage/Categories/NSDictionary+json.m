//
//  NSDictionary+json.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSDictionary+json.h"

@implementation NSMutableDictionary (json)

+ (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)aString
{
    NSLog(@"market message string '%@'", aString);
    
    NSData *jsonData = [aString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:jsonData
                     options:NSJSONReadingMutableContainers
                     error:&error];
    
    if (error)
    {
        NSLog(@"JSON Parse Error: %@", [[error userInfo] objectForKey:@"NSDebugDescription"]);
        return nil;
    }
    
    if (![jsonObject isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    return jsonObject;
}

@end

@implementation NSDictionary (json)

- (NSString *)asJsonString
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (error)
    {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

}

@end

@implementation NSDictionary (path)

- (id)objectForPath:(NSString *)path
{
    NSArray *parts = [path componentsSeparatedByString:@"/"];
    id value = self;
    
    for (NSString *part in parts)
    {
        value = [value objectForKey:part];
    }
    
    return value;
}

@end

