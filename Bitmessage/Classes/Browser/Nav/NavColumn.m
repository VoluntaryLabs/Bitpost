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
#import "NSEvent+keys.h"
//#import "NavRowView.h"
#import "Theme.h"
#import "NSObject+extra.h"
#import <objc/runtime.h>

@implementation NavColumn

- (BOOL)isOpaque
{
    return NO;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    self.actionStripHeight = 40.0;
    [self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:NSViewHeightSizable /* | NSViewWidthSizable*/];
    [self setupSubviews];
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubviews
{
    CGFloat h = self.actionStripHeight;
    self.actionStrip = [[NSView alloc] initWithFrame:NSMakeRect(0, self.height - h, self.width, h)];
    [self addSubview:self.actionStrip];
    
    // scrollview
    
    self.scrollView = [[NSScrollView alloc] initWithFrame:self.scollFrameSansStrip];
    [self addSubview:self.scrollView];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalRuler:NO];
    [self.scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
    
    [self.scrollView setAutoresizesSubviews:YES];
    [self.scrollView setAutoresizingMask:NSViewHeightSizable];
    
    // table
    
    self.tableView = [[NSTableView alloc] initWithFrame:self.scrollView.bounds];
    [self.tableView setIntercellSpacing:NSMakeSize(0, 0)];
    
    [self.tableView setAutoresizesSubviews:YES];
    [self.tableView setAutoresizingMask:NSViewHeightSizable];
    
    self.tableColumn = [[NSTableColumn alloc] init];
    [self.tableColumn setDataCell:[[TableCell alloc] init]];
    [self.tableView addTableColumn:self.tableColumn];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    [self.tableView setHeaderView:nil];
    [self.tableView setFocusRingType:NSFocusRingTypeNone];
    
    if (NO)
    {
        self.documentView = [[ColoredView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
        [self.scrollView setDocumentView:self.documentView];
        [self.documentView setFrame:NSMakeRect(0, 0, 1000, 1000)];
        
        
         self.headerView = [[ColoredView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 150)];
         if (self.headerView)
         {
             [self.documentView addSubview:self.headerView];
         }
        
        [self.documentView addSubview:self.tableView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateDocumentView:)
                                                     name:@"NSViewFrameDidChangeNotification"
                                                   object:self.tableView];
    }
    else
    {
        [self.scrollView setDocumentView:self.tableView];
    }
    
    [self setRowHeight:60];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self.actionStrip setWidth:frameRect.size.width];
}

- (NSRect)scollFrameSansStrip
{
    NSRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.height -= self.actionStripHeight;
    return frame;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self prepareToDisplay];
    /*
     NSRect f = self.drawFrame;
     
     [[self bgColor] set];
     NSRectFill(f);
     [super drawRect:f];
     */
}

// ----------------------------------------

- (BOOL)selectedNodeWasRemoved
{
    return ![self.node.children containsObject:[self selectedNode]];
}

- (void)reloadData
{
    NSInteger row = self.tableView.selectedRow;
    NSInteger maxRow = self.node.children.count - 1;
    
    if (row < 0)
    {
        row = 0;
    }
    
    if (row > maxRow)
    {
        row = maxRow;
    }
    
    [self.tableView reloadData];
    
    if (_lastSelectedChild)
    {
        NSInteger nodeRow = [self rowForNode:_lastSelectedChild];
        //NSLog(@"get _lastSelectedChild %@ row %i", _lastSelectedChild, (int)nodeRow);
        
        if (nodeRow != -1)
        {
            row = nodeRow;
        }
    }
    
    [self selectRowIndex:row];
    //[self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    [self.navView reloadedColumn:self];
}

- (void)nodeRemovedChild:(NSNotification *)note
{
    // note should ideally include hint at next to select in case
    // children change before notification is received?
    
    /*
    id nextObject = [[note userInfo] objectForKey:@"nextObjectHint"];
    
    if (nextObject)
    {
        NSInteger row = [self rowForNode:nextObject];
        
        if (row != -1)
        {
            [self selectRowIndex:row];
        }
    }
    */

    [self reloadData];
}

- (void)nodeAddedChild:(NSNotification *)note
{
    id <NavNode> node = self.node;
    
    if (node)
    {
        if([node shouldSelectChildOnAdd])
        {
            id child = [[note userInfo] objectForKey:@"child"];
            /*
            if ([child respondsToSelector:@selector(label)])
            {
                NSLog(@"child.label = '%@'", [child label]);
            }
            */
            _lastSelectedChild = child;
        }
    }
    
    [self reloadData];
}

- (void)nodeChanged:(NSNotification *)note
{
    [self reloadData];
}

- (void)selectRowIndex:(NSInteger)rowIndex
{
    [self tableView:self.tableView shouldSelectRow:rowIndex];
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] byExtendingSelection:NO];
    _lastSelectedChild = self.selectedNode;
}

- (BOOL)selectItemNamed:(NSString *)aName
{
    NSInteger rowIndex = 0;
    
    for (id <NavNode> child in self.node.children)
    {
        if ([[child nodeTitle] isEqualToString:aName])
        {
            [self selectRowIndex:rowIndex];
            return YES;
        }
        
        rowIndex ++;
    }
    
    return NO;
}

- (void)setRowHeight:(CGFloat)height
{
    [self.tableView setRowHeight:height];
}

- (void)setMaxWidth:(CGFloat)w
{
    [self.tableColumn setMaxWidth:w];
    [self.scrollView setWidth:w];
    [self.tableView setWidth:w];
    //[self.navView stackViews];
    [self setWidth:w];
}

- (void)setNode:(id<NavNode>)node
{
    if (_node != node)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];

        _node = node;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(nodeChanged:)
                                                     name:@"BMNodeChanged"
                                                   object:_node];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(nodeRemovedChild:)
                                                     name:@"BMNodeRemovedChild"
                                                   object:_node];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(nodeAddedChild:)
                                                     name:@"BMNodeAddedChild"
                                                   object:_node];
        
        
        if (![node nodeView])
        {
            [self setMaxWidth:node.nodeSuggestedWidth];
        }
        
        [self.tableView reloadData];

        if ([node respondsToSelector:@selector(columnBgColor)])
        {
            if ([node columnBgColor])
            {
                [self.tableView setBackgroundColor:[node columnBgColor]];
            }
        }
        
        [self updateActionStrip];
        
    }
}

- (void)didAddToNavView
{
    if ([self.node nodeView] && [[self.node children] count] == 0)
    {
        NSView *nodeView = [self.node nodeView];
        
        [self setWidth:fabs(self.navView.width - self.x)];
        /*
        [self setHeight:self.navView.height];
        [nodeView setX:0];
        [nodeView setY:0];
        */
        [nodeView setFrameSize:self.frame.size];
        
        NSLog(@"nodeView x %i", (int)nodeView.x);
        
        [self setContentView:nodeView];
    }
    
    [self.tableView setBackgroundColor:self.themeDict.bgInactiveColor];
    // if using document view
    [self.documentView setBackgroundColor:self.tableView.backgroundColor];
    //[self.scrollView setBackgroundColor:self.tableView.backgroundColor];
}

- (void)updateDocumentView:(NSNotification *)note
{
    NSLog(@"tableFrameDidChangeNotification");
    
    if (!self.isUpdating &&
        //[note object] == self.tableView &&
        !NSEqualRects(self.documentView.bounds, self.tableView.bounds))
    {
        CGFloat fullHeight = [self.documentView sumOfSubviewHeights];
        
        if (fullHeight < self.scrollView.height)
        {
            fullHeight = self.scrollView.height;
        }
        
        NSRect newFrame = self.tableView.bounds;
        newFrame.size.height = fullHeight;
        
        self.isUpdating = YES;
        [self.documentView setFrame:newFrame];
        
        [self.documentView stackSubviewsTopToBottom];
        
        //[self.tableView setY:newFrame.size.height - self.tableView.height];
        self.isUpdating = NO;
    }
}



- (NSInteger)columnIndex
{
    return [self.navView indexOfColumn:self];
}

- (void)prepareToDisplay
{
    if (self.scrollView.superview)
    {
        [self setMaxWidth:self.node.nodeSuggestedWidth];
    }
    else if (self.contentView)
    {
        [self setMaxWidth:self.contentView.width];
    }
    
    //[self setMaxWidth:400];

}

- (ThemeDictionary *)themeDict
{
    return [Theme.sharedTheme themeForColumn:self.columnIndex];
}


- (void)setContentView:(NSView *)aView
{
    //aView = [[ColoredView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    //[(ColoredView *)aView setBackgroundColor:[NSColor redColor]];
    [self setAutoresizesSubviews:YES];
    [aView setAutoresizingMask:aView.autoresizingMask | NSViewWidthSizable];
    
    [self.scrollView removeFromSuperview];
    [self.contentView removeFromSuperview];
    _contentView = aView;
    
    self.contentView.frame = self.scollFrameSansStrip;
    [self addSubview:self.contentView];
    [self setNeedsDisplay:YES];
}

- (void)setupHeaderView:(NSView *)aView
{
    [self.tableView removeFromSuperview]; // so views are in correct order

    if (self.headerView)
    {
        [self.headerView removeFromSuperview];
    }
    
    //[self setMaxWidth:aView.i];
    self.headerView = (ColoredView *)aView;
    [self.documentView addSubview:aView];
    [self.documentView addSubview:self.tableView];
    [self updateDocumentView:nil];
}

- (id <NavNode>)nodeForRow:(NSInteger)rowIndex
{
    if (rowIndex < self.node.children.count)
    {
        return [self.node.children objectAtIndex:rowIndex];
    }
    
    return nil;
}

- (NSInteger)rowForNode:(id <NavNode>)aNode
{
    NSInteger rowIndex = 0;
    
    for (id childNode in self.node.children)
    {
        if (childNode == aNode)
        {
            return rowIndex;
        }
        
        rowIndex ++;
    }
    
    return -1;
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

// --- methods to deal with header ---

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)rowIndex
{
    return self.tableView.rowHeight;
}


// --- normal delegate methods ---

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    id <NavNode> node = [self nodeForRow:rowIndex];
    _lastSelectedChild = node;
    return [self.navView shouldSelectNode:node inColumn:self];
}

/*
// This was slow and choppy. Why?
 
- (NSView *)tableView:(NSTableView *)aTableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
    NavRowView *rowView = [aTableView makeViewWithIdentifier:@"NavRowView" owner:self];
    //NavRowView *rowView = [[NavRowView alloc] initWithFrame:NSMakeRect(0, 0, self.width, aTableView.rowHeight)];
    //NavRowView *rowView = [[NavRowView alloc] initWithFrame:NSMakeRect(0, 0, self.width, aTableView.rowHeight)];
    if (!rowView)
    {
        rowView = [[NavRowView alloc] initWithFrame:NSZeroRect];
    }
    ///[rowView setIsSelected:[aTableView selectedRow] == rowIndex];
    [rowView setNode:[self nodeForRow:rowIndex]];
    rowView.tableView = aTableView;
    rowView.rowIndex = rowIndex;
    return rowView;
}
*/


- (void)tableView:(NSTableView *)aTableView
    willDisplayCell:(id)aCell
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex
{
    [aCell setIsSelected:[aTableView selectedRow] == rowIndex];
    [aCell setNode:[self nodeForRow:rowIndex]];
    [aCell setNavColumn:self];
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

// --- actions ---

- (BOOL)canHandleAction:(SEL)aSel
{
    return [self.node respondsToSelector:aSel];
}

- (void)handleAction:(SEL)aSel
{
    if ([self.node respondsToSelector:aSel])
    {
        [(NSObject *)self.node noWarningPerformSelector:aSel];
    }
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)keyDown:(NSEvent *)event
{
    //NSLog(@"class %@ got key down", NSStringFromClass([self class]));
    
    if ([event isDeleteDown])
    {
        [self delete];
    }
    else if ([event isLeftArrow])
    {
        [self leftArrow];
    }
    else if ([event isRightArrow])
    {
        [self rightArrow];
    }
}

- (void)delete
{
    id node = [self selectedNode];
    
    if ([node respondsToSelector:@selector(delete)])
    {
        [node noWarningPerformSelector:@selector(delete)];
    }
}

- (void)leftArrow
{
    [self.navView leftArrowFrom:self];
}

- (void)rightArrow
{
    [self.navView rightArrowFrom:self];
}

// --- action strip ----------------------------------------

- (void)updateActionStrip
{
    //NSLog(@"updateActionStrip");
    
    for (NSView *view in [NSArray arrayWithArray:[self.actionStrip subviews]])
    {
        [view removeFromSuperview];
    }
    
    [self setAutoresizesSubviews:YES];
    
    for (NSString *action in self.node.actions)
    {
        CGFloat buttonHeight = 40;
        //CGFloat y = self.actionStrip.height/2 - buttonHeight/2;
        NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 80, buttonHeight)];
        [button setButtonType:NSMomentaryChangeButton];
        [button setBordered:NO];
        [button setFont:[NSFont fontWithName:[Theme.sharedTheme lightFontName] size:14.0]];
        [button setAutoresizingMask: NSViewMinXMargin | NSViewMaxYMargin];
        
        /*
         NSString *imageName = [NSString stringWithFormat:@"%@_active", action];
         NSImage *image = [NSImage imageNamed:imageName];
         if (image)
         {
         [button setImage:image];
         [button setWidth:image.size.width*3];
         }
         else
         */
        {
            NSDictionary *att = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [button font], NSFontAttributeName,
                                 nil];
            CGFloat width = [[[NSAttributedString alloc] initWithString:action attributes:att] size].width;
            [button setTitle:action];
            [button setWidth:width+10];
        }
        
        [button setTarget:self];
        [button setAction:@selector(hitActionButton:)];
        [self.actionStrip addSubview:button];
        
        objc_setAssociatedObject(button, @"action", action, OBJC_ASSOCIATION_RETAIN);
    }
    
    /*
     if ([lastNode canSearch])
     {
     NSSearchField *search = [[CustomSearchField alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
     [self.actionStrip addSubview:search];
     }
     */
    
    [self.actionStrip stackSubviewsRightToLeft];
    [self.actionStrip adjustSubviewsX:-20];
    
}

- (void)hitActionButton:(id)aButton
{
    NSString *action = objc_getAssociatedObject(aButton, @"action");
    NSLog(@"hit action %@", action);
    
    [(id)self.node noWarningPerformSelector:NSSelectorFromString(action) withObject:nil];
}


@end
