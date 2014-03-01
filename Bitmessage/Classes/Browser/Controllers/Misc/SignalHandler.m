//
//  SignalHandler.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SignalHandler.h"

@protocol SignalHandler <NSObject>

- (void)handleSignal:(int)aSignal;

@end

@implementation SignalHandler

+ (void)setup
{
    InstallSignalnHandler();
}

void SignalHandlerFunc(int signal)
{
    printf("SignalHandler caught signal %i - shutting down server and exiting \n", signal);
    id <SignalHandler> obj = (id <SignalHandler>)[[NSApplication sharedApplication] delegate];
    [obj handleSignal:signal];
}

void InstallSignalnHandler()
{
    printf("InstallSignalnHandler\n");
	signal(SIGABRT, SignalHandlerFunc);
	signal(SIGALRM, SignalHandlerFunc);
	signal(SIGVTALRM, SignalHandlerFunc);
	signal(SIGPROF, SignalHandlerFunc);
	signal(SIGBUS, SignalHandlerFunc);
	signal(SIGCHLD, SignalHandlerFunc);
	signal(SIGFPE, SignalHandlerFunc);
	signal(SIGHUP, SignalHandlerFunc);
	signal(SIGILL, SignalHandlerFunc);
	signal(SIGINT, SignalHandlerFunc);
	signal(SIGKILL, SignalHandlerFunc);
    
    //prctl(PR_SET_PDEATHSIG, SIGKILL)
    
	signal(SIGPIPE, SignalHandlerFunc);
	signal(SIGQUIT, SignalHandlerFunc);
	signal(SIGSEGV, SignalHandlerFunc);
	signal(SIGSTOP, SignalHandlerFunc);
	signal(SIGTERM, SignalHandlerFunc);
	signal(SIGTSTP, SignalHandlerFunc);
    
    signal(SIGTTIN, SignalHandlerFunc);
	signal(SIGTTOU, SignalHandlerFunc);
    
	signal(SIGUSR1, SignalHandlerFunc);
	signal(SIGUSR2, SignalHandlerFunc);
    
	//signal(SIGPOLL, SignalHandlerFunc);
	signal(SIGSYS, SignalHandlerFunc);
	signal(SIGTRAP, SignalHandlerFunc);
    
	signal(SIGURG, SignalHandlerFunc);
	signal(SIGXCPU, SignalHandlerFunc);
	signal(SIGXFSZ, SignalHandlerFunc);
    
    //signal(SIGRTMIN, SignalHandlerFunc);
	//signal(SIGRTMAX, SignalHandlerFunc);
}

@end
