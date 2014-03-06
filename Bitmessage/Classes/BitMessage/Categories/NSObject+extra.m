//
//  NSObject+extra.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSObject+extra.h"

@implementation NSObject (extra)

+ (Class)viewClass
{
    NSString *className = [NSStringFromClass([self class]) stringByAppendingString:@"View"];
    id viewClass = NSClassFromString(className);
    return viewClass;
}

+ (Class)firstViewClass
{
    id viewClass = self.class.viewClass;
    
    if (viewClass)
    {
        return viewClass;
    }
    
    if (self.superclass)
    {
        return self.superclass.firstViewClass;
    }
    
    return nil;
}

- (void)noWarningPerformSelector:(SEL)aSelector
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:aSelector];
    #pragma clang diagnostic pop
}


- (void)noWarningPerformSelector:(SEL)aSelector withObject:anArgument
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:aSelector withObject:anArgument];
    #pragma clang diagnostic pop
}

@end
