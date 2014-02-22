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
#import "BMProxyMessage.h"

@implementation BMServerProcess

static BMServerProcess *shared = nil;

+ (BMServerProcess *)sharedBMServerProcess
{
    if (!shared)
    {
        shared = [[BMServerProcess alloc] init];
    }
    
    return shared;
}

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
    pid_t pid = [_task processIdentifier];
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
    /*
    if (self.isLastServerRunning)
    {
        return;
    }
    */
    
    if (self.isRunning)
    {
        return;
    }
    
    //[self killLastServerIfNeeded];
    
    _task = (Task *)[[NSTask alloc] init];
    _inpipe = [NSPipe pipe];
    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
    NSMutableDictionary *environment = [NSMutableDictionary dictionaryWithDictionary:environmentDict];
    NSLog(@"%@", [environment valueForKey:@"PATH"]);
    
    // Set environment variables containing api username and password
    [environment setObject: @"bitmarket" forKey:@"PYBITMESSAGE_USER"];
    [environment setObject: @"87342873428901648473823" forKey:@"PYBITMESSAGE_PASSWORD"];
    [_task setEnvironment: environment];
    
    // Set the path to the python executable
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString * pythonPath = [mainBundle pathForResource:@"python" ofType:@"exe" inDirectory: @"static-python"];
    NSString * pybitmessagePath = [mainBundle pathForResource:@"bitmessagemain" ofType:@"py" inDirectory: @"pybitmessage"];
    [_task setLaunchPath:pythonPath];
    
    NSFileHandle *nullFileHandle = [NSFileHandle fileHandleWithNullDevice];
    [_task setStandardOutput:nullFileHandle];
    [_task setStandardInput: (NSFileHandle *) _inpipe];
    //[_task setStandardError:nullFileHandle];
    
    [_task setArguments:@[ pybitmessagePath ]];
   
    [_task launch];
    
    if (![_task isRunning])
    {
        NSLog(@"task not running after launch");
    }
    else
    {
        for (int i = 0; i < 5; i ++)
        {
            if ([self canConnect])
            {
                NSLog(@"connected to server");
                break;
            }
            NSLog(@"waiting to connect to server...");
            sleep(1);
        }
    }
}

- (void)terminate
{
    NSLog(@"Killing pybitmessage process...");
    [_task terminate];
    self.task = nil;
    [self forgetServerPid];
}

- (BOOL)isRunning
{
    //return [self isLastServerRunning] || (_task && [_task isRunning]);
    return (_task && [_task isRunning]);
}

- (BOOL)canConnect
{
    BMProxyMessage *message = [[BMProxyMessage alloc] init];
    [message setMethodName:@"helloWorld"];
    NSArray *params = [NSArray arrayWithObjects:@"hello", @"world", nil];
    [message setParameters:params];
    //message.debug = YES;
    [message sendSync];
    NSString *response = [message responseValue];
    return [response isEqualToString:@"hello-world"];
}

@end
