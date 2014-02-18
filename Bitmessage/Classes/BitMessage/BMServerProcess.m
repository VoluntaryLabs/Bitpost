//
//  BMServerProcess.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "BMServerProcess.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <unistd.h>
#include <errno.h>

@implementation BMServerProcess

- (NSNumber *)lastServerPid
{
    NSNumber *pidNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverPid"];
    return pidNumber;
}

- (BOOL)isLastServerRunning
{
    NSNumber *pidNumber = [self lastServerPid];
    
    if (pidNumber)
    {
        int result = kill([pidNumber intValue], 0);
        return result == 0;
    }
    
    return NO;
}

- (void)rememberServerPid
{
    pid_t pid = [_pybitmessage processIdentifier];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:pid] forKey:@"serverPid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)forgetServerPid
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"serverPid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)killLastServerIfNeeded
{
    NSNumber *pidNumber = [self lastServerPid];
    
    if (pidNumber)
    {
        NSLog(@"killing old server with pid %@", pidNumber);
        
        int result = kill([pidNumber intValue], SIGKILL);
        
        if (result == -1)
        {
            NSLog(@"unable to kill old server with pid %@, errno %i", pidNumber, (int)errno);
        }
        else
        {
            //sleep(3);
        }
        
        [self forgetServerPid];
    }

}

- (void)launch
{
    if (self.isLastServerRunning)
    {
        //return;
    }
    
    if (self.isRunning)
    {
        return;
    }
    
    [self killLastServerIfNeeded];
    
    self.pybitmessage = [[NSTask alloc] init];
    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
    NSMutableDictionary *environment = [NSMutableDictionary dictionaryWithDictionary:environmentDict];
    NSLog(@"%@", [environment valueForKey:@"PATH"]);
    
    // Set environment variables containing api username and password
    [environment setObject: @"bitmarket" forKey:@"PYBITMESSAGE_USER"];
    [environment setObject: @"87342873428901648473823" forKey:@"PYBITMESSAGE_PASSWORD"];
    [_pybitmessage setEnvironment: environment];
    
    // Set the path to the python executable
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString * pythonPath = [mainBundle pathForResource:@"python" ofType:@"exe" inDirectory: @"static-python"];
    NSString * pybitmessagePath = [mainBundle pathForResource:@"bitmessagemain" ofType:@"py" inDirectory: @"pybitmessage"];
    [_pybitmessage setLaunchPath:pythonPath];
    
    NSFileHandle *nullFileHandle = [NSFileHandle fileHandleWithNullDevice];
    [_pybitmessage setStandardOutput:nullFileHandle];
    //[_pybitmessage setStandardError:nullFileHandle];
    
    [_pybitmessage setArguments:@[ pybitmessagePath ]];
    
    [_pybitmessage launch];
    [self rememberServerPid];
    
    // -------------
    //pid_t group = getsid(0);

    //printf("sid %i\n", (int)group);

    /*
    pid_t group = setsid();
    if (group == -1)
    {
        group = getpgrp();
    }
    */
    /*
    pid_t group = getpgrp();
    printf("gid %i\n", (int)group);
   
    [_pybitmessage launch];
    
    pid_t pid = [_pybitmessage processIdentifier];
    printf("pid %i\n", (int)pid);
    errno = 0;
    int result = setpgid(pid, group);
    printf("errno %i\n",(int)errno);
    
    printf("EACCES %i\n",(int)EACCES);
    printf("EINVAL %i\n",(int)EINVAL);
    printf("EPERM %i\n",(int)EPERM);
    printf("ESRCH %i\n",(int)ESRCH);
    
    if (result == -1)
    {
        NSLog(@"unable to put task into same group as self");
        [self terminate];
    }
    */
}

- (void)terminate
{
    NSLog(@"Killing pybitmessage process...");
    [_pybitmessage terminate];
    self.pybitmessage = nil;
    [self forgetServerPid];
}

- (BOOL)isRunning
{
    return [self isLastServerRunning] || (self.pybitmessage && [_pybitmessage isRunning]);
}

@end
