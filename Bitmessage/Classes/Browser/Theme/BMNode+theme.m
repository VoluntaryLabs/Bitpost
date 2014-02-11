//
//  BMNode+theme.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/7/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode+theme.h"
#import "Theme.h"

@implementation BMNode (theme)

- (NSColor *)columnBgColor
{
    return [Theme objectForKey:[NSString stringWithFormat:@"%@-columnBgColor",
                                NSStringFromClass([self class])]];
}

- (CGFloat)nodeSuggestedWidth
{
    NSNumber *num = [Theme objectForKey:[NSString stringWithFormat:@"%@-nodeSuggestedWidth",
                                NSStringFromClass([self class])]];

    if (num)
    {
        return [num floatValue];
    }

    return 300;
}


- (NSColor *)bgColorActive
{
    return [Theme objectForKey:[NSString stringWithFormat:@"%@-bgColorActive",
                                NSStringFromClass([self class])]];
}

- (NSColor *)bgColorInactive
{
    return [Theme objectForKey:[NSString stringWithFormat:@"%@-bgColorInactive",
                                NSStringFromClass([self class])]];
}


@end
