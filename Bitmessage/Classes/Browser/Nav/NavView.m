//
//  NavView.m
//  Bitmarket
//
//  Created by Steve Dekorte on 2/5/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NavView.h"
#import "NavColumn.h"
#import "NSView+sizing.h"
#import <objc/runtime.h>

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
    [self updateActionStrip];
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

- (BOOL)canHandleAction:(SEL)aSel
{
    id lastColumn = [self.navColumns lastObject];
    return [lastColumn canHandleAction:aSel];
}

- (void)handleAction:(SEL)aSel
{
    id lastColumn = [self.navColumns lastObject];
    [lastColumn handleAction:aSel];
}

- (void)reloadedColumn:(NavColumn *)aColumn
{
    [self updateActionStrip];
}

- (id <NavNode>)lastNode
{
    NSEnumerator *e = [self.navColumns reverseObjectEnumerator];
    id column = nil;
    while (column = [e nextObject])
    {
        if ([column respondsToSelector:@selector(node)])
        {
            return [column node];
        }
    }
    return nil;
}

- (void)updateActionStrip
{
    for (NSView *view in [NSArray arrayWithArray:[self.actionStrip subviews]])
    {
        [view removeFromSuperview];
    }
    
    id <NavNode> lastNode = [self lastNode];
    id lastButton = nil;
    
    [self setAutoresizesSubviews:YES];
    
    for (NSString *action in lastNode.actions)
    {
        NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 80, 20)];
        [button setButtonType:NSMomentaryChangeButton];
        [button setBordered:NO];
        [button setFont:[NSFont fontWithName:@"Open Sans Light" size:14.0]];
        [button setAutoresizingMask: NSViewMinXMargin | NSViewMaxYMargin];
        
        NSString *imageName = [NSString stringWithFormat:@"%@_active", action];
        NSImage *image = [NSImage imageNamed:imageName];
        if (image)
        {
            [button setImage:image];
            [button setWidth:image.size.width*3];
        }
        else
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
        
        if (lastButton)
        {
            //[button setX:[lastButton maxX] + 15];
            [button setX:[lastButton x] - 15 - [button width]];
        }
        else
        {
            [button setX:self.actionStrip.width - button.width];
        }
        
        objc_setAssociatedObject(button, @"action", action, OBJC_ASSOCIATION_RETAIN);
        
        lastButton = button;
    }
    
}

- (void)hitActionButton:(id)aButton
{
    NSString *action = objc_getAssociatedObject(aButton, @"action");
    NSLog(@"hit action %@", action);
    
    id lastColumn = [self.navColumns lastObject];
    id <NavNode> lastNode = [lastColumn node];
    [lastNode performSelector:NSSelectorFromString(action) withObject:nil];
    
}

@end
