//
//  NavNode.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/7/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NavNode <NSObject>

- (id <NavNode>)nodeParent;

- (NSMutableArray *)children;

// inlines

- (NSArray *)inlinedChildren;
- (BOOL)shouldInlineChildren;
- (BOOL)nodeParentInlines;
- (BOOL)nodeShouldIndent;

- (NSMutableArray *)actions;

- (NSString *)nodeTitle;
- (NSString *)nodeSubtitle;
- (NSString *)nodeNote;
- (BOOL)isRead;

- (NSArray *)nodeTitlePath:(NSArray *)pathComponents;

- (NSString *)iconName; // so it can add "Selected" for highlighted version?

- nodeView; // NavColumn view if nil, otherwise an effective preview view
- (NSImage *)nodeIconForState:(NSString *)aState;
- (CGFloat)nodeSuggestedWidth;
- (CGFloat)nodeSuggestedRowHeight;

- (BOOL)shouldSelectChildOnAdd;

- (BOOL)canSearch;
- (void)search:(NSString *)aString;
- (NSMutableArray *)searchResults;

- (NSString *)verifyActionMessage:(NSString *)aString;

@end