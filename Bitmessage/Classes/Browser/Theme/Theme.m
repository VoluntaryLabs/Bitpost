//
//  Theme.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/7/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "Theme.h"
#import "NSColor+array.h"

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
    [self load];
    return self;
}

- (void)load
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"themes" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError *error;
    
    id jsonObject = [NSJSONSerialization
                 JSONObjectWithData:jsonData
                 options:0
                 error:&error];
    
    self.themeDicts = jsonObject;
    
    if (error)
    {
        NSLog(@"JSON Parse Error: %@", [[error userInfo] objectForKey:@"NSDebugDescription"]);
        [NSException raise:@"JSON Parse Error" format:@""];
    }
    
    //NSLog(@"themeDicts: %@", self.themeDicts);
}

- (NSDictionary *)currentTheme
{
    return [self.themeDicts objectForKey:@"default"];
}

- (id)objectForKey:(NSString *)k
{
    return [self.currentTheme objectForKey:k];
}

- (NSColor *)colorForKey:(NSString *)k
{
    return [NSColor withArray:[self.currentTheme objectForKey:k]];
}

+ (id)objectForKey:(NSString *)k
{
    return [self.sharedTheme objectForKey:k];
}

// --- column themes ---------------------------

- (ThemeDictionary *)themeForColumn:(NSInteger)columnIndex
{
    NSArray *columnThemes = [self.currentTheme objectForKey:@"columns"];
    NSDictionary *dict = columnThemes.lastObject;
    
    if (columnIndex < columnThemes.count)
    {
        dict = [columnThemes objectAtIndex:columnIndex];
    }
    
    return [ThemeDictionary withDict:dict];
}

// helpers


- (NSColor *)formBackgroundColor
{
    return [self colorForKey:@"formBackgroundColor"];
}

- (NSColor *)formText1Color
{
    return [self colorForKey:@"formText1Color"];
}

- (NSColor *)formText2Color
{
    return [self colorForKey:@"formText2Color"];
}

- (NSColor *)formText3Color
{
    return [self colorForKey:@"formText3Color"];
}

- (NSColor *)formText4Color
{
    return [self colorForKey:@"formText4Color"];
}

- (NSColor *)formTextErrorColor
{
    return [self colorForKey:@"formTextErrorColor"];
}

- (NSColor *)formTextSelectedBgColor
{
    return [self colorForKey:@"formTextSelectedBgColor"];
}

- (NSColor *)formTextCursorColor
{
    return [self colorForKey:@"formTextCursorColor"];
}

- (NSColor *)formTextLinkColor
{
    return [self colorForKey:@"formTextLinkColor"];
}

// draft

- (NSColor *)draftTopBgColor
{
    return [self colorForKey:@"draftTopBgColor"];
}

- (NSColor *)draftBgColor
{
    return [self colorForKey:@"draftBgColor"];
}

- (NSColor *)draftBodyTextColor
{
    return [self colorForKey:@"draftBodyTextColor"];
}

- (NSColor *)draftBodyTextSelectedColor
{
    return [self colorForKey:@"draftBodyTextSelectedColor"];
}

- (NSColor *)draftFieldTextColor
{
    return [self colorForKey:@"draftFieldTextColor"];
}

- (NSColor *)draftLabelTextColor
{
    return [self colorForKey:@"draftLabelTextColor"];
}

// font

- (NSString *)lightFontName
{
    return [self.currentTheme objectForKey:@"lightFontName"];
}

- (NSString *)mediumFontName
{
    return [self.currentTheme objectForKey:@"mediumFontName"];
}

// forward

/*
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    
    if (!signature)
    {
        signature = [super methodSignatureForSelector:@selector(init)];
    }
    
    return signature;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSString *propertyName = NSStringFromSelector(aSelector);
    //return [self.currentTheme objectForKey:propertyName] != nil;
    return YES;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *propertyName = NSStringFromSelector([anInvocation selector]);
    id result = nil;
    
    if ([propertyName hasSuffix:@"Color"])
    {
        result = [self colorForKey:propertyName]];
    }
    else
    {
        result = [self.currentTheme objectForKey:propertyName];
    }
    
    if (result == nil)
    {
        NSLog(@"nil result");
    }
    
    [anInvocation setReturnValue:(void *)result];
    [anInvocation retainArguments];
}
*/

@end
