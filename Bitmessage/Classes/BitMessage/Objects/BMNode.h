//
//  BMNode.h
//  Bitmarket
//
//  Created by Steve Dekorte on 1/31/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+BM.h"

@class BMNode;

@interface BMNode : NSObject

@property (assign, nonatomic) BMNode *nodeParent;
@property (strong, nonatomic) NSMutableArray *children;
@property (strong, nonatomic) NSMutableArray *actions;
@property (strong, nonatomic) NSView *nodeView;

- (void)addChild:(id)aChild;
- (void)removeChild:(id)aChild;

- (NSString *)nodeTitle;
- (NSImage *)nodeIconForState:(NSString *)aState;

//- (CGFloat)nodeSuggestedWidth;

- (void)deepFetch;
- (void)fetch;
- (void)refresh;

- (void)postParentChanged;
- (void)postSelfChanged;

@end
