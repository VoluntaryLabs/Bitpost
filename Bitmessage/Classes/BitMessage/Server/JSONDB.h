//
//  JSONDB.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONDB : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableDictionary *dict;

- (void)read;
- (void)write;

//+ (NSMutableDictionary *)readDictWithName:(NSString *)aName;
//+ (void)writeDict:(NSMutableDictionary *)dict withName:(NSString *)aName;

@end
