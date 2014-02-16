//
//  NavNode.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/7/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NavNode <NSObject>

- (NSMutableArray *)children;
- (NSMutableArray *)actions;

- (NSString *)nodeTitle;
- (NSString *)nodeSubtitle;
- (NSString *)nodeNote;

- (NSString *)iconName; // so it can add "Selected" for highlighted version?

- nodeView; // NavColumn view if nil, otherwise an effective preview view
- (NSImage *)nodeIconForState:(NSString *)aState;
- (CGFloat)nodeSuggestedWidth;
- (NSColor *)columnBgColor;

@end