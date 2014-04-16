//
//  MKCategory.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKCategory.h"
#import <BitMessageKit/BitMessageKit.h>
#import "AppController.h"

@implementation MKCategory

- (NSString *)dbName
{
    return @"categories.json";
}

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    if (self.children.count == 0)
    {
        [self setCanPost:YES];
    }
}

- (void)add
{
    /*
    // find a way to move this to UI layer
    
    BMClient *client = [BMClient sharedBMClient];
    MKMarkets *markets = [client markets];
    MKSells *sells = [markets sells];
    MKSell *sell = [sells justAdd];
    
    NSArray *nodes = [NSArray arrayWithObjects:client, markets, sells, sell, nil];
    
    NSLog(@"%@", self.groupPath);
    
    AppController *app = (AppController *)[[NSApplication sharedApplication] delegate];
    [app.navView selectNodePath:nodes];
     */
}

@end
