//
//  MKCategory.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMNode.h"

@interface MKCategory : BMNode

@property (strong, nonatomic) NSString *name;

- (void)setCanPost:(BOOL)aBool;

- (void)read;
- (void)write;

- (NSArray *)categorySubpaths;
- (NSArray *)catPath;

@end
