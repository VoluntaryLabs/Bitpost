//
//  Theme.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/7/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeDictionary.h"

@interface Theme : NSObject

@property (strong) NSMutableDictionary *dict;
@property (strong, nonatomic) NSMutableDictionary *themeDicts;

+ (Theme *)sharedTheme;

+ (id)objectForKey:(NSString *)k;
- (id)objectForKey:(NSString *)key;

- (ThemeDictionary *)themeForColumn:(NSInteger)columnIndex;

// --- helpers ---

// form

- (NSColor *)formBackgroundColor;
- (NSColor *)formText1Color;
- (NSColor *)formText2Color;
- (NSColor *)formText3Color;
- (NSColor *)formText4Color;
- (NSColor *)formTextErrorColor;
- (NSColor *)formTextSelectedBgColor;
- (NSColor *)formTextCursorColor;
- (NSColor *)formTextLinkColor;


// fonts

- (NSString *)lightFontName;
- (NSString *)mediumFontName;

// paths

- (id)objectForPath:(NSString *)key;
- (NSColor *)colorForPath:(NSString *)key;
- (NSDictionary *)attributesDictForPath:(NSString *)path; // e,g, "item/selected"

@end

@interface NSView (theme)
- (void)setSelectedThemePath:(NSString *)aPath;
- (void)setThemePath:(NSString *)aPath;
@end

/*
@interface NSTextView (theme)
- (void)setThemePath:(NSString *)aPath;
@end

@interface NSTextField (theme)
- (void)setThemePath:(NSString *)aPath;
@end
 */


