//
//  MKGroup.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/24/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BitmessageKit.h>

@interface MKGroup : BMNode

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger count;

+ (MKGroup *)rootInstance;

- (void)setDict:(NSDictionary *)dict;

- (void)setCanPost:(BOOL)aBool;

- (void)read;
- (void)write;

- (NSArray *)groupSubpaths;
- (NSArray *)groupPath;

- (void)updateCounts;

@end
