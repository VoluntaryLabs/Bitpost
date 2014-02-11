//
//  NavView.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NavView.h"
#import "NavColumn.h"

@implementation NavView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    self.navColumns = [NSMutableArray array];
    
    return self;
}

- (void)setRootNode:(id<NavNode>)rootNode
{
    _rootNode = rootNode;
    [self reload];
}

- (void)reload
{
    for (NavColumn *column in self.navColumns)
    {
        [column removeFromSuperview];
    }
    self.navColumns = [NSMutableArray array];
    
    [self addColumnForNode:self.rootNode];
}

- (void)addColumnForNode:(id <NavNode>)node
{
    NavColumn *column = nil;
    
    if ([node respondsToSelector:@selector(nodeView)] && [node nodeView])
    {
        column = [node nodeView];
        [column setFrameSize:NSMakeSize(self.frame.size.width - self.columnsWidth, self.frame.size.height)];
    }
    else
    {
        column = [[NavColumn alloc] initWithFrame:NSMakeRect(0, 0, 250, self.frame.size.height)];
    }

    [self.navColumns addObject:column];
    [self addSubview:column];
    
    [column setNavView:self];

    [column setNode:node];

    [self stackViews];
}

- (CGFloat)columnsWidth
{
    NSView *lastColumn = self.navColumns.lastObject;
    NSRect f = lastColumn.frame;
    return f.origin.x + f.size.width;
}

- (void)stackViews
{
    CGFloat x = 0;

    for (NavColumn *column in self.navColumns)
    {
        NSRect f = [column frame];
        f.origin.x = x;
        x += f.size.width;
        f.size.height = self.frame.size.height;
        column.frame = f;
    }
}

- (BOOL)shouldSelectNode:(id <NavNode>)node inColumn:inColumn
{
    NSMutableArray *toRemove = [NSMutableArray array];
    
    BOOL hitColumn = NO;
    for (NavColumn *column in self.navColumns)
    {
        if (hitColumn)
        {
            [toRemove addObject:column];
            [column removeFromSuperview];
        }
        
        if (inColumn == column)
        {
            hitColumn = YES;
        }
    }
    
    [self.navColumns removeObjectsInArray:toRemove];
    
    [self addColumnForNode:node];
    return YES;
}

- (NSColor *)bgColor
{
    return [NSColor colorWithCalibratedWhite:031.0/255.0 alpha:1.0];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[self bgColor] set];
    [NSBezierPath fillRect:dirtyRect];
    [super drawRect:dirtyRect];
}

@end
