//
//  MKCategory.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKCategory.h"
#import "JSONDB.h"
#import "BMClient.h"
#import "AppController.h"

@implementation MKCategory

- (id)init
{
    self = [super init];
    self.actions = [NSMutableArray arrayWithObjects:@"add", nil];
    return self;
}

- (NSString *)nodeTitle
{
    return self.name;
}

- (JSONDB *)db
{
    JSONDB *db = [[JSONDB alloc] init];
    [db setName:@"categories.json"];
    db.isInAppWrapper = YES;
    return db;
}

- (void)read
{
    JSONDB *db = self.db;
    [db read];
    [self setDict:db.dict];
}

- (void)write
{
    //
}

- (void)setCanPost:(BOOL)aBool
{
    BOOL hasAdd = [self.actions containsObject:@"add"];
    
    if (aBool)
    {
        if (!hasAdd)
        {
            [self.actions addObject:@"add"];
        }
    }
    else
    {
        if (hasAdd)
        {
            [self.actions removeObject:@"add"];
        }
    }
}

+ (MKCategory *)withDict:(NSDictionary *)dict
{
    MKCategory *obj = [[MKCategory alloc] init];
    [obj setDict:dict];
    return obj;
}

- (void)setDict:(NSDictionary *)dict
{
    self.name = [dict objectForKey:@"name"];
    NSArray *childrenDicts = [dict objectForKey:@"children"];
    
    if (childrenDicts)
    {
        NSMutableArray *children = [NSMutableArray array];
        
        for (NSDictionary *childDict in childrenDicts)
        {
            [children addObject:[MKCategory withDict:childDict]];
        }
            
        
        [self setChildren:children];
    }
    
    //[self sortChildren];
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.name forKey:@"name"];
    NSMutableArray *childrenDicts = [NSMutableArray array];
    
    for (MKCategory *child in self.children)
    {
        [childrenDicts addObject:[child dict]];
    }
    
    [dict setObject:childrenDicts forKey:@"children"];
    return dict;
}

- (void)add
{
    // find a way to move this to UI layer
    
    BMClient *client = [BMClient sharedBMClient];
    MKMarkets *markets = [client markets];
    MKSells *sells = [markets sells];
    MKSell *sell = [sells justAdd];
    
    NSArray *nodes = [NSArray arrayWithObjects:client, markets, sells, sell, nil];
    
    AppController *app = (AppController *)[[NSApplication sharedApplication] delegate];
    [app.navView selectNodePath:nodes];
}

- (CGFloat)nodeSuggestedWidth
{
    return 200;
}

- (NSArray *)catPath
{
    if ([self.nodeParent isKindOfClass:[MKCategory class]])
    {
        MKCategory *parentCat = (MKCategory *)self.nodeParent;
        return [[parentCat catPath] arrayByAddingObject:self.name];
    }
    
    return [NSArray arrayWithObject:self.name];
}

- (NSArray *)categorySubpaths
{
    NSMutableArray *paths = [NSMutableArray array];
    
    for (MKCategory *cat in self.children)
    {
        if ([cat isKindOfClass:[MKCategory class]])
        {
            //[paths addObject:[NSArray arrayWithObjects:self.name, cat.name, nil]];
            [paths addObject:cat.catPath];
        }
    }
    
    return paths;
}

@end
