//
//  NSColor+array.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/14/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSColor+array.h"
#import "NSColor+Hex.h"

@implementation NSColor (array)

+ (NSColor *)colorWithObject:(id)value
{
    if ([value isKindOfClass:[NSArray class]])
    {
        return [NSColor withArray:value];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [NSColor colorFromHexadecimalValue:value];
    }
    
    [NSException raise:@"Invalid value" format:@"Color value must be an rgba array or hex string"];
    return nil;
    
}

+ (NSColor *)withArray:(NSArray *)colorArray
{
    if (colorArray.count == 1)
    {
        NSNumber *w = [colorArray objectAtIndex:0];
        return [NSColor colorWithCalibratedWhite:w.doubleValue alpha:1.0];
    }
    else if (colorArray.count == 2)
    {
        NSNumber *w = [colorArray objectAtIndex:0];
        NSNumber *a = [colorArray objectAtIndex:1];
        
        return [NSColor colorWithCalibratedWhite:w.doubleValue alpha:a.doubleValue];
    }
    else if (colorArray.count == 3)
    {
        NSNumber *r = [colorArray objectAtIndex:0];
        NSNumber *g = [colorArray objectAtIndex:1];
        NSNumber *b = [colorArray objectAtIndex:2];
        
        return [NSColor colorWithCalibratedRed:r.doubleValue
                                         green:g.doubleValue
                                          blue:b.doubleValue
                                         alpha:1.0];
    }
    
    else if (colorArray.count == 4)
    {
        NSNumber *r = [colorArray objectAtIndex:0];
        NSNumber *g = [colorArray objectAtIndex:1];
        NSNumber *b = [colorArray objectAtIndex:2];
        NSNumber *a = [colorArray objectAtIndex:3];
        
        return [NSColor colorWithCalibratedRed:r.doubleValue
                                         green:g.doubleValue
                                          blue:b.doubleValue
                                         alpha:a.doubleValue];
    }
    else
    {
        [NSException raise:@"Invalid Color Format" format:@""];
    }
    
    return nil;

}

@end
