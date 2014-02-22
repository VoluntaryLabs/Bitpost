//
//  BMServerProcess.h
//  Bitmessage
//
//  Created by Steve Dekorte on 2/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface BMServerProcess : NSObject

+ (BMServerProcess *)sharedBMServerProcess;

@property (strong) Task *task;
@property (strong) NSPipe *inpipe;

@property (retain, nonatomic) NSString *host;
@property (assign) int port;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

- (void)launch;
- (BOOL)isRunning;
- (void)terminate;
- (BOOL)canConnect;
//- (NSString *)status;

@end
