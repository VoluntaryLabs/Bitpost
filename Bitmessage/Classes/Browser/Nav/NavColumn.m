//
//  NavColumn.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NavColumn.h"
#import "TableCell.h"
#import "NSView+sizing.h"

@implementation NavColumn

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    [self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:NSViewHeightSizable /* | NSViewWidthSizable*/];
    [self setupTable];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)selectedNodeWasRemoved
{
    return ![self.node.children containsObject:[self selectedNode]];
}

- (void)reloadData
{
    [self.tableView reloadData];
    [self.navView reloadedColumn:self];
}

- (void)nodeRemovedChild:(NSNotification *)note
{
    //id childNode = [[note userInfo] objectForKey:@"child"];

    [self reloadData];
    
    NSInteger max = self.node.children.count - 1;
    NSInteger selectedIndex = [self.tableView selectedRow];
    
    
    if (selectedIndex > max || selectedIndex == -1)
    {
        selectedIndex = max;
    }
    
    [self selectRowIndex:selectedIndex];
}


- (void)nodeChanged:(NSNotification *)note
{
    //BOOL removedSelected = [self selectedNodeWasRemoved];
    //NSInteger selectedIndex = [self.tableView selectedRow];

    [self reloadData];
    /*
     
    if (removedSelected)
    {
        NSInteger max = self.node.children.count - 1;
        
        if (selectedIndex > max)
        {
            selectedIndex = max;
        }
        
        [self selectRowIndex:selectedIndex];
    }
    */
}

- (void)selectRowIndex:(NSInteger)rowIndex
{
    [self tableView:self.tableView shouldSelectRow:rowIndex];

    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] byExtendingSelection:NO];
}

- (void)setRowHeight:(CGFloat)height
{
    [self.tableView setRowHeight:height];
}

- (void)setMaxWidth:(CGFloat)w
{
    [self.tableColumn setMaxWidth:w];
    
    [self setWidth:w];
    [self.scrollView setWidth:w];
    [self.tableView setWidth:w];
    [self.navView stackViews];
}

- (void)setNode:(id<NavNode>)node
{
    _node = node;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BMNodeChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BMMessageRemovedChild" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nodeChanged:) name:@"BMNodeChanged" object:node];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nodeRemovedChild:) name:@"BMMessageRemovedChild" object:node];
    
    
    [self setMaxWidth:node.nodeSuggestedWidth];
    [self.tableView reloadData];

    if ([node respondsToSelector:@selector(columnBgColor)])
    {
        if ([node columnBgColor])
        {
            [self.tableView setBackgroundColor:[node columnBgColor]];
        }
    }
}

- (void)setupTable
{
    self.scrollView = [[NSScrollView alloc] initWithFrame:self.frame];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalRuler:NO];
    [self.scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
    
    [self.scrollView setAutoresizesSubviews:YES];
    [self.scrollView setAutoresizingMask:NSViewHeightSizable /*| NSViewWidthSizable*/];
    
    self.tableView = [[NSTableView alloc] initWithFrame:self.scrollView.bounds];
    
    [self.tableView setAutoresizesSubviews:YES];
    [self.tableView setAutoresizingMask:NSViewHeightSizable /*| NSViewWidthSizable*/];
    
    [self.tableView setBackgroundColor:[NSColor colorWithCalibratedWhite:031.0/255.0 alpha:1.0]];
    self.tableColumn = [[NSTableColumn alloc] init];
    [self.tableColumn setDataCell:[[TableCell alloc] init]];
    [self.tableView addTableColumn:self.tableColumn];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    [self.tableView setHeaderView:nil];
    [self.tableView setFocusRingType:NSFocusRingTypeNone];
    
    [self.scrollView setDocumentView:self.tableView];
    [self addSubview:self.scrollView];

    [self setRowHeight:60];
    [self setMaxWidth:400];
}

- (id <NavNode>)nodeForRow:(NSInteger)rowIndex
{
    return [self.node.children objectAtIndex:rowIndex];
}

// table data source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [self.node.children count];
}

- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(NSInteger)rowIndex
{
    return [[self.node.children objectAtIndex:rowIndex] nodeTitle];
}

// table delegate

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    id <NavNode> node = [self nodeForRow:rowIndex];
    //if ([node respondsToSelector:@selector(<#selector#>)])
    return [self.navView shouldSelectNode:node inColumn:self];
}

- (void)tableView:(NSTableView *)aTableView
    willDisplayCell:(id)aCell
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex
{
    [aCell setIsSelected:[aTableView selectedRow] == rowIndex];
    [aCell setNode:[self nodeForRow:rowIndex]];
}

- (id <NavNode>)selectedNode
{
    NSInteger selectedRow = [self.tableView selectedRow];
    
    if (selectedRow >= 0)
    {
        return [self nodeForRow:selectedRow];
    }
    
    return nil;
}

- (BOOL)canHandleAction:(SEL)aSel
{
    return [self.node respondsToSelector:aSel];
}

- (void)handleAction:(SEL)aSel
{
    if ([self.node respondsToSelector:aSel])
    {
        [self.node performSelector:aSel];
    }
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent
{
    NSLog(@"class %@ got key down", NSStringFromClass([self class]));
}

@end
