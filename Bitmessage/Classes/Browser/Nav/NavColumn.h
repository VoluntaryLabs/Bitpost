//
//  NavColumn.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NavView.h"
#import "ColoredView.h"

@interface NavColumn : NSView <NSTableViewDataSource, NSTableViewDelegate>

@property (assign, nonatomic) id navView;
@property (strong, nonatomic) id <NavNode> node;

@property (strong, nonatomic) NSScrollView *scrollView;
@property (strong, nonatomic) NSTableView *tableView;
@property (strong, nonatomic) NSTableColumn *tableColumn;
@property (strong, nonatomic) ColoredView *documentView; // view within scrollview containing headerView and tableView

@property (strong, nonatomic) ColoredView *headerView; // top of document view

@property (strong, nonatomic) NSView *contentView; // replaces scrollview

@property (strong, nonatomic) ColoredView *actionStrip;
@property (assign, nonatomic) BOOL isUpdating;
@property (assign, nonatomic) CGFloat actionStripHeight;

@property (strong, nonatomic) id <NavNode> lastSelectedChild;

- (void)didAddToNavView;
- (void)prepareToDisplay;
- (ThemeDictionary *)themeDict;

- (id <NavNode>)selectedNode;

- (void)selectRowIndex:(NSInteger)rowIndex;

- (void)setupHeaderView:(NSView *)aView;
- (void)setContentView:(NSView *)aView;

- (BOOL)selectItemNamed:(NSString *)aName;

@end
