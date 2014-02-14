//
//  Theme.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/7/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "Theme.h"

@implementation Theme

static Theme *sharedTheme = nil;

+ (Theme *)sharedTheme
{
    if (!sharedTheme)
    {
        sharedTheme = [[[self class] alloc] init];
    }
    
    return sharedTheme;
}

- (id)init
{
    self = [super init];
    self.dict = [NSMutableDictionary dictionary];
    [self setup];
    return self;
}

- (void)setup
{
    [self setObject:[NSColor colorWithCalibratedWhite:.12 alpha:1.0] forKey:@"BMClient-columnBgColor"];
    [self setObject:[NSNumber numberWithInteger:100] forKey:@"BMClient-nodeSuggestedWidth"];
    
    //[self setObject:[NSColor blueColor] forKey:@"BMSentMessages-active"];
    //[self setObject:[NSColor blueColor] forKey:@"BMSentMessages-inactive"];
    
    NSColor *column1Color = [NSColor colorWithCalibratedWhite:.09 alpha:1.0];
    
    [self setObject:column1Color forKey:@"BMSentMessages-columnBgColor"];
    [self setObject:column1Color forKey:@"BMReceivedMessages-columnBgColor"];
    [self setObject:column1Color forKey:@"BMContacts-columnBgColor"];
    [self setObject:column1Color forKey:@"BMIdentities-columnBgColor"];

    
    NSColor *bgColorActive = [NSColor colorWithCalibratedWhite:018.0/255.0 alpha:1.0];
    NSColor *bgColorInactive = [NSColor colorWithCalibratedWhite:023.0/255.0 alpha:1.0];
    
    [self setObject:bgColorActive forKey:@"BMMessage-bgColorActive"];
    [self setObject:bgColorInactive forKey:@"BMMessage-bgColorInactive"];
    
    [self setObject:bgColorActive forKey:@"BMIdentity-bgColorActive"];
    [self setObject:bgColorInactive forKey:@"BMIdentity-bgColorInactive"];
    
    [self setObject:[NSColor whiteColor] forKey:@"BMContact-textColor"];
    [self setObject:bgColorActive forKey:@"BMContact-bgColorActive"];
    [self setObject:bgColorInactive forKey:@"BMContact-bgColorInactive"];
    
    [self setObject:[NSColor colorWithRed:0.70f green:0.69f blue:0.98f alpha:1.0f] forKey:@"BMMessage-unreadTextColor"];
    [self setObject:[NSColor colorWithCalibratedWhite:.5 alpha:1.0] forKey:@"BMMessage-readTextColor"];
    [self setObject:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] forKey:@"BMMessage-textColorActive"];
}

- (id)objectForKey:(NSString *)k
{
    return [self.dict objectForKey:k];
}

- (void)setObject:(id)anObject forKey:(NSString *)k
{
    [self.dict setObject:anObject forKey:k];
}

// ----------------------

+ (id)objectForKey:(NSString *)k
{
    return [self.sharedTheme objectForKey:k];
}

+ (void)setObject:(id)anObject forKey:(NSString *)k
{
    return [self.sharedTheme setObject:anObject forKey:k];
}

@end
