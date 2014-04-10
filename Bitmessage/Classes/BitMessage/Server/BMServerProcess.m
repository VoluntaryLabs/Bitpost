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
        shared = [BMServerProcess alloc];
        shared = [shared init];
    }
    
    return shared;
}

- (id)init
{
    self = [super init];
    self.host = @"127.0.0.1";
    self.port = 8442;
    self.username = @"bitmarket";
    self.password = @"87342873428901648473823";
    
    self.keysFile = [[BMKeysFile alloc] init];
    [self setupKeysDat];
    return self;
}

- (long)entropy
{
    // yeah, this isn't great
    unsigned int entropy = (unsigned int)time(NULL) + (unsigned int)clock();
    srandom(entropy);
    return random();
}

- (void)randomizeLogin
{
    self.username = [NSString stringWithFormat:@"%i", (int)self.entropy];
    self.password = [NSString stringWithFormat:@"%i", (int)self.entropy];
    [self.keysFile setApiUsername:self.username];
    [self.keysFile setApiPassword:self.password];
}

- (void)setupKeysDat
{
    [self.keysFile backup];
    [self.keysFile setupForDaemon];
    [self randomizeLogin];
}

- (BOOL)setLabel:(NSString *)aLabel onAddress:(NSString *)anAddress
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProgressPush" object:self];
    [self terminate];
    [self.keysFile setLabel:aLabel onAddress:anAddress];
    [self launch];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProgressPop" object:self];
    return YES;
}

- (void)launch
{
    if (self.isRunning)
    {
        NSLog(@"Attempted to launch BM server more than once.");
        return;
    }
    
    _task = [[NSTask alloc] init];
    _inpipe = [NSPipe pipe];
    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
    NSMutableDictionary *environment = [NSMutableDictionary dictionaryWithDictionary:environmentDict];
    NSLog(@"%@", [environment valueForKey:@"PATH"]);
    
    // Set environment variables containing api username and password
    [environment setObject:self.username forKey:@"PYBITMESSAGE_USER"];
    [environment setObject:self.password forKey:@"PYBITMESSAGE_PASSWORD"];
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
        [self waitOnConnect];
    }
}

- (BOOL)waitOnConnect
{
    for (int i = 0; i < 5; i ++)
    {
        if ([self canConnect])
        {
            NSLog(@"connected to server");
            return YES;
        }
        
        NSLog(@"waiting to connect to server...");
        sleep(1);
    }
    
    return NO;
}

- (void)terminate
{
    NSLog(@"Killing pybitmessage process...");
    [_task terminate];
    self.task = nil;
    [self.keysFile setupForNonDaemon];
}

- (BOOL)isRunning
{
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

- (NSString *)serverDataFolder
{
    return [@"~/Library/Application Support/PyBitmessage" stringByExpandingTildeInPath];
}

@end
