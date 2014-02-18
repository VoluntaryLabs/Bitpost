//
//  BMServerProcess.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMServerProcess : NSObject

@property (strong) NSTask *pybitmessage;

- (void)launch;
- (BOOL)isRunning;
- (void)terminate;

@end
