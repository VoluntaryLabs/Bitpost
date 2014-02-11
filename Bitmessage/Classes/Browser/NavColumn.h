//
//  NavColumn.h
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NavView.h"

@interface NavColumn : NSView <NSTableViewDataSource, NSTableViewDelegate>

@property (assign, nonatomic) id navView;
@property (strong, nonatomic) id <NavNode> node;


@property (strong, nonatomic) NSScrollView *scrollView;
@property (strong, nonatomic) NSTableView *tableView;
@property (strong, nonatomic) NSTableColumn *tableColumn;

- (void)selectRowIndex:(NSInteger)rowIndex;

@end
