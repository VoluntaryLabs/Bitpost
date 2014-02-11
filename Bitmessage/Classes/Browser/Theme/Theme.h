//
//  Theme.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/7/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

@property (strong) NSMutableDictionary *dict;

+ (Theme *)sharedTheme;

+ (id)objectForKey:(NSString *)k;
+ (void)setObject:(id)anObject forKey:(NSString *)k;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)anObject forKey:(NSString *)key;

@end
