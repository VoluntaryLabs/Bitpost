//
//  Task.h
//
//  Created by Steve Dekorte on 2/18/14.
//

#import <Foundation/Foundation.h>
#include "callsystem.h"

@interface Task : NSObject
{
    char **_env;
	char **_args;
	callsystem_fd_t _stdin_child[2];
	callsystem_fd_t _stdout_child[2];
	callsystem_fd_t _stderr_child[2];
	callsystem_pid_t _pid;
	int _status;
	int _needsClose;
}

@property (strong, nonatomic) NSString *launchPath;
@property (strong, nonatomic) NSArray *arguments;
@property (strong, nonatomic) NSDictionary *environment;

@property (strong, nonatomic) NSFileHandle *standardInput;
@property (strong, nonatomic) NSFileHandle *standardOutput;
@property (strong, nonatomic) NSFileHandle *standardError;

//@property (assign) int terminationStatus;

- (int)processIdentifier;

- (void)launch;
- (void)terminate;
- (void)waitUntilExit;
- (BOOL)isRunning;


@end
