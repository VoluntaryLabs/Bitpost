//
//  NavRowView.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NavView.h"

@interface NavRowView : NSTableRowView

@property (assign, nonatomic) CGFloat leftMarginRatio;
@property (strong, nonatomic) id <NavNode> node;
//@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) NSTableView *tableView;
@property (assign, nonatomic) NSInteger rowIndex;

@end
