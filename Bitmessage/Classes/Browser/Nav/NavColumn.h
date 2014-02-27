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
@property (strong, nonatomic) ColoredView *documentView;
@property (strong, nonatomic) ColoredView *headerView;
@property (assign, nonatomic) BOOL isUpdating;

- (id <NavNode>)selectedNode;

- (void)selectRowIndex:(NSInteger)rowIndex;
- (void)setupHeaderView:(NSView *)aView;

- (BOOL)selectItemNamed:(NSString *)aName;

@end
