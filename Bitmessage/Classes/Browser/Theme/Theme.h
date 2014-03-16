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

// draft

- (NSColor *)draftTopBgColor;
- (NSColor *)draftBgColor;
- (NSColor *)draftBodyTextColor;
- (NSColor *)draftBodyTextSelectedColor;
- (NSColor *)draftFieldTextColor;
- (NSColor *)draftLabelTextColor;

// fonts

- (NSString *)lightFontName;
- (NSString *)mediumFontName;

@end
