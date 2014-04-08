//
//  NavView.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NavNode.h"
#import "Theme.h"

@class NavColumn;

@interface NavView : NSView

@property (strong, nonatomic) NSMutableArray *navColumns;
@property (strong, nonatomic) id <NavNode> rootNode;
//@property (strong, nonatomic) IBOutlet NSSearchField *searchField;
@property (assign, nonatomic) CGFloat actionStripHeight;

- (BOOL)shouldSelectNode:(id <NavNode>)node inColumn:inColumn;

- (BOOL)canHandleAction:(SEL)aSel;
- (void)handleAction:(SEL)aSel;

//- (void)reloadedColumn:(NavColumn *)aColumn;

- (void)leftArrowFrom:aColumn;
- (void)rightArrowFrom:aColumn;

- (void)selectNodePath:(NSArray *)nodes;

- (NSInteger)indexOfColumn:(NavColumn *)aColumn;
- (NavColumn *)columnForNode:(id)node;

@end
