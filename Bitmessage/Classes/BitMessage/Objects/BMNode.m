//
//  BMNode.m
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"

@implementation BMNode

- (id)init
{
    self = [super init];
    
    self.children = [NSMutableArray array];
    self.actions  = [NSMutableArray array];
    //[self.actions addObject:@"testAction"];
    
    return self;
}

- (void)deepFetch
{
    [self fetch];
    
    for (id child in self.children)
    {
        if ([child respondsToSelector:@selector(fetch)])
        {
            [child deepFetch];
        }
    }
}

- (void)fetch
{
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
    }
}

- (void)removeChild:(id)aChild
{
    [self.children removeObject:aChild];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"BMMessageRemovedChild" object:self.nodeParent];

    NSNotification *note = [NSNotification  notificationWithName:@"BMMessageRemovedChild" object:self userInfo:[NSDictionary dictionaryWithObject:aChild forKey:@"child"]];
    
    [[NSNotificationCenter defaultCenter] postNotification:note];

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

- (void)postChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BMNodeChanged" object:self.nodeParent];
}


- (NSView *)nodeView
{
    if (!_nodeView)
    {
        NSString *className = [NSStringFromClass([self class]) stringByAppendingString:@"View"];
        id viewClass = NSClassFromString(className);
        
        if (viewClass)
        {
            _nodeView = [(NSView *)[viewClass alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
        }
    }
    
    return _nodeView;
}


@end
