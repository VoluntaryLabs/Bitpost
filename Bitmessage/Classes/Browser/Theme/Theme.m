//
//  Theme.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/7/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//


//NSSound *systemSound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/dock/drag to trash.aif" byReference:YES];
/*
 /System/Library/Sounds
 Here the list of sounds found in that directory:
 Basso
 Blow
 Bottle
 Frog
 Funk
 Glass
 Hero
 Morse
 Ping
 Pop
 Purr
 Sosumi
 Submarine
 Tink
 */

//    NSSound *newMessageSound = [[NSSound alloc] initWithContentsOfFile:@"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/dock/drag to trash.aif" byReference:YES];

//[newMessageSound play];

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
    NSColor *column2Color = [NSColor colorWithCalibratedWhite:.09 alpha:1.0];
    
    [self setObject:column2Color forKey:@"Messages-columnBgColor"];
    
    
    [self setObject:column1Color forKey:@"BMSentMessages-columnBgColor"];
    [self setObject:column1Color forKey:@"BMReceivedMessages-columnBgColor"];
    [self setObject:column1Color forKey:@"BMContacts-columnBgColor"];
    [self setObject:column1Color forKey:@"BMIdentities-columnBgColor"];
    [self setObject:column1Color forKey:@"BMChannels-columnBgColor"];
    [self setObject:column1Color forKey:@"BMSubscriptions-columnBgColor"];

    
    NSColor *bgColorActive = [NSColor colorWithCalibratedWhite:018.0/255.0 alpha:1.0];
    NSColor *bgColorInactive = [NSColor colorWithCalibratedWhite:023.0/255.0 alpha:1.0];
    
    
    [self setObject:bgColorActive forKey:@"BMIdentity-bgColorActive"];
    [self setObject:bgColorInactive forKey:@"BMIdentity-bgColorInactive"];
    
    [self setObject:[NSColor whiteColor] forKey:@"BMContact-textColor"];
    [self setObject:bgColorActive forKey:@"BMContact-bgColorActive"];
    [self setObject:bgColorInactive forKey:@"BMContact-bgColorInactive"];
    
    [self setColorsOn:@"BMSentMessage"];
    [self setColorsOn:@"BMReceivedMessage"];
    [self setColorsOn:@"BMChannel"];
    [self setColorsOn:@"BMSubscription"];
}

- (void)setColorsOn:(NSString *)aName
{
    NSColor *bgColorActive = [NSColor colorWithCalibratedWhite:018.0/255.0 alpha:1.0];
    NSColor *bgColorInactive = [NSColor colorWithCalibratedWhite:023.0/255.0 alpha:1.0];
    
    [self setObject:[NSColor colorWithRed:0.70f green:0.69f blue:0.98f alpha:1.0f]
             forKey:[aName stringByAppendingString:@"-unreadTextColor"]];
    [self setObject:[NSColor colorWithCalibratedWhite:.5 alpha:1.0]
             forKey:[aName stringByAppendingString:@"-readTextColor"]];
    [self setObject:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]
             forKey:[aName stringByAppendingString:@"-textColorActive"]];
    [self setObject:bgColorActive
             forKey:[aName stringByAppendingString:@"-bgColorActive"]];
    [self setObject:bgColorInactive
             forKey:[aName stringByAppendingString:@"-bgColorInactive"]];
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
