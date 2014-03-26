//
//  BMNode.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"
#import "NSObject+extra.h"
#import "BMClient.h"

@implementation BMNode

- (id)init
{
    self = [super init];
    
    self.children = [NSMutableArray array];
    self.actions  = [NSMutableArray array];
    //[self.actions addObject:@"testAction"];
    
    self.shouldSortChildren = YES;
    
    return self;
}

- (void)deepFetch
{
    [self fetch];
    
    for (id child in self.children)
    {
        if ([child respondsToSelector:@selector(fetch)])
        {
            //NSLog(@"child %@", child);
            [child deepFetch];
        }
    }
}

- (void)fetch
{
    
}

- (void)refresh
{
    [self fetch];
    [self postSelfChanged];
}

- (NSUInteger)nodeDepth
{
    NSUInteger depth = 0;
    BMNode *nodeParent = self.nodeParent;
    
    while (nodeParent)
    {
        depth ++;
        nodeParent = nodeParent.nodeParent;
    }
    
    return depth;
}


- (void)setChildren:(NSMutableArray *)children
{
    _children = children;

    for (BMNode *child in self.children)
    {
        [child setNodeParent:self];
    }
}

- (void)addChild:(id)aChild
{
    if (![self.children containsObject:aChild])
    {
        [aChild setNodeParent:self];
        [self.children addObject:aChild];
        [self sortChildren];
       
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:aChild forKey:@"child"];
        
        NSNotification *note = [NSNotification notificationWithName:@"BMNodeAddedChild"
                                                             object:self
                                                           userInfo:info];
        
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
    else
    {
        [self sortChildren];
    }
}

- (void)removeChild:(id)aChild
{
    NSInteger i = [self.children indexOfObject:aChild];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:aChild forKey:@"child"];
    [info setObject:[NSNumber numberWithUnsignedInteger:i] forKey:@"index"];
    
    NSInteger nextIndex = i + 1;
    if (nextIndex < self.children.count)
    {
        id nextObject = [self.children objectAtIndex:nextIndex];
        [info setObject:nextObject forKey:@"nextObjectHint"];
    }
    
    [self.children removeObject:aChild];

    NSNotification *note = [NSNotification notificationWithName:@"BMNodeRemovedChild"
                                                         object:self
                                                       userInfo:info];
    
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)sortChildren
{
    if (self.shouldSortChildren)
    {
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"nodeTitle"
                                                                 ascending:YES
                                                                  selector:@selector(caseInsensitiveCompare:)];

        //NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"nodeTitle" ascending:YES];
        [self.children sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    }
}

- (BMNode *)childWithTitle:(NSString *)aTitle
{
    for (BMNode *child in self.children)
    {
        if ([[child nodeTitle] isEqualToString:aTitle])
        {
            return child;
        }
    }
    
    return nil;
}

- (NSArray *)nodeTitlePath:(NSArray *)pathComponents
{
    BMNode *node = self;
    NSMutableArray *nodes = [NSMutableArray array];
    
    for (NSString *title in pathComponents)
    {
        node = [node childWithTitle:title];
        
        if (node == nil)
        {
            break;
        }
        
        [nodes addObject:node];
    }
    
    return nodes;
}

- (NSString *)nodeTitle
{
    NSString *name = NSStringFromClass([self class]);
    NSString *prefix = @"BM";
    
    if ([name hasPrefix:prefix])
    {
        name = [name substringFromIndex:[prefix length]];
        name = [name lowercaseString];
    }
    
    return name;
}

- (NSString *)nodeSubtitle
{
    return nil;
}

// --- icon ----------------------

- (NSImage *)nodeIconForState:(NSString *)aState
{
    NSString *className = NSStringFromClass([self class]);
    NSString *iconName = [NSString stringWithFormat:@"%@_%@", className, aState];
    //NSLog(@"iconName: %@", iconName);
    //iconName = nil;
    return [NSImage imageNamed:iconName];
}

- (NSImage *)nodeActiveIcon
{
    return [self nodeIconForState:@"active"];
}

- (NSImage *)nodeInactiveIcon
{
    return [self nodeIconForState:@"inactive"];
}

- (NSImage *)nodeDisabledIcon
{
    return [self nodeIconForState:@"disabled"];
}

- (void)postParentChanged
{
    [self.nodeParent postSelfChanged];
}

- (void)postSelfChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BMNodeChanged" object:self];
}

- (NSView *)nodeView
{
    if (!_nodeView)
    {
        id viewClass = self.class.firstViewClass;
        
        if (viewClass)
        {
            _nodeView = [(NSView *)[viewClass alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
            
            //SEL aSelector = NSSelectorFromString(@"setNode:");
            if ([_nodeView respondsToSelector:@selector(setNode:)])
            {
                [_nodeView performSelector:@selector(setNode:) withObject:self];
            }
        }
    }
    
    return _nodeView;
}

- (BOOL)canSearch
{
    return NO;
}

- (void)search:(NSString *)aString
{
    
}

- (id)childWithAddress:(NSString *)address
{
    for (id child in self.children)
    {
        if ([child respondsToSelector:@selector(address)])
        {
            if([(NSString *)[child address] isEqualToString:address])
            {
                return child;
            }
        }
    }
    
    return nil;
}

- (BMClient *)client
{
    return [BMClient sharedBMClient];
}

// ----------------------

- (NSArray *)inlinedChildren
{
    NSMutableArray *inlinedChildren = [NSMutableArray array];
    
    for (BMNode *child in self.children)
    {
        [inlinedChildren addObject:child];
        [inlinedChildren addObjectsFromArray:child.children];
    }
    
    return inlinedChildren;
}

- (BOOL)nodeParentInlines
{
    if (self.nodeParent)
    {
        return self.nodeParent.shouldInlineChildren;
    }
    
    return NO;
}

- (BOOL)nodeShouldIndent
{
    BMNode *p = self.nodeParent;
    
    if (p)
    {
        p = p.nodeParent;
        
        if (p)
        {
            return p.shouldInlineChildren;
        }
    }
    
    return NO;
}

- (CGFloat)nodeSuggestedRowHeight
{
    if (self.shouldInlineChildren)
    {
        return 30;
    }
    
    return 60;
}



@end
