//
//  NSObject+extra.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (extra)

+ (Class)viewClass;
+ (Class)firstViewClass;

- (void)noWarningPerformSelector:(SEL)aSelector;
- (void)noWarningPerformSelector:(SEL)aSelector withObject:anArgument;

@end
