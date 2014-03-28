//
//  NSDictionary+json.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (json)

+ (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)aString;

@end

@interface NSDictionary (json)

- (NSString *)asJsonString;

@end

@interface NSDictionary (path)

- (id)objectForPath:(NSString *)path;

@end