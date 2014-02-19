//
//  Task.m
//
//  Created by Steve Dekorte on 2/18/14.
//

#import "Task.h"

@implementation Task

- (id)init
{
    self = [super init];
    
    self.launchPath = nil;
    self.arguments = [NSArray array];
    self.environment = [NSDictionary dictionary];
    
    [self clearPipeDescriptors];
    return self;
}

- (void)clearPipeDescriptors
{
	_stdin_child[0] =
	_stdin_child[1] = CALLSYSTEM_ILG_FD;
	_stdout_child[0] =
	_stdout_child[1] = CALLSYSTEM_ILG_FD;
	_stderr_child[0] =
	_stderr_child[1] = CALLSYSTEM_ILG_FD;
}

- (void)dealloc
{
	[self rawClose];
}

/* ----------------------------------------------------------- */

- (void)launch
{
	//doc SystemCall asyncRun(command, argList, envMap) Run the system call.

	int err;
    
	/*if you want C FILE streams*/
	/* STREAMING THESE TO A SEQUENCE CAN CAUSE DEADLOCK!!!
	 * WE NEED TO FIND A WORKAROUND
	 UPDATE: this object is pointless without the streams (use Io's System system() instead)
	 so either fix the streams here or don't use this object, but don't remove this object's streams.
     */
	FILE *fchildin;
	FILE *fchildout;
	FILE *fchilderr;
    
	[self rawClose];
    
	/*open the filehandles as pipes*/
	callsystem_pipe(_stdin_child);
	callsystem_pipe(_stdout_child);
	callsystem_pipe(_stderr_child);
    
	/*initialize the C FILE streams*/
	fchildin  = callsystem_fdopen(_stdin_child,  CALLSYSTEM_MODE_WRITE); /* the parent process wants to WRITE to stdin of the child */
	fchildout = callsystem_fdopen(_stdout_child, CALLSYSTEM_MODE_READ); /* the parent process wants to READ stdout of the child */
	fchilderr = callsystem_fdopen(_stderr_child, CALLSYSTEM_MODE_READ); /* the parent process wants to READ from stderr of the child */
    
    
	_pid = CALLSYSTEM_ILG_PID;
    
    for (NSString *key in [self.environment allKeys])
    {
        NSString *value = [self.environment objectForKey:key];
        callsystem_setenv(&(_env), [key UTF8String], [value UTF8String]);
    }
    
    for (NSString *argString in self.arguments)
    {
        callsystem_argv_pushback(&_args, [argString UTF8String]);
    }
    
    
	err = callsystem([self.launchPath UTF8String],
                     _args,
                     _env,

                     _stdin_child,
                     _stdout_child,
                     _stderr_child,
                     
                     NULL,
                     0,
                     &(_pid));
    
	NSLog(@"callsystem %@ pid %i", self.launchPath, _pid);
    
	_needsClose = 1;
    
	if (err != -1)
	{
        self.standardInput = [[NSFileHandle alloc]
                                initWithFileDescriptor:fileno(fchildin) closeOnDealloc:YES];

        self.standardOutput = [[NSFileHandle alloc]
                                initWithFileDescriptor:fileno(fchildout) closeOnDealloc:YES];
        
        self.standardError = [[NSFileHandle alloc]
                                initWithFileDescriptor:fileno(fchilderr) closeOnDealloc:YES];
        
		/*
         Now that we've handed the C FILE* over to the Io File
         Objects they are responsible for closing the file.
         So we must forget the "descriptors".
		 */
        
		[self clearPipeDescriptors];
	}
    
	//return err;
}

- (int)status
{
	int pid = _pid;
	int status = callsystem_running(&pid);
	_pid = pid;
	return status;
}

- (id)close
{
	[self rawClose];
	return self;
}

- (void)rawClose
{
	//printf("IoSystemCall_rawClose(%p) 1\n", (void *)self);
    
	if (_needsClose)
	{
		//printf("IoSystemCall_rawClose(%p)\n", (void *)self);
		callsystem_close(_stdin_child);
		callsystem_close(_stdout_child);
		callsystem_close(_stderr_child);
		callsystem_argv_clear(&_args);
		callsystem_env_clear(&_env);
		//if (_pid)
		{
			//printf("callsystem_finished(%i)\n", _pid);
			callsystem_finished(&(_pid));
			_pid = 0;
		}
        
		_needsClose = 0;
	}
}

- (int)processIdentifier
{
    return _pid;
}

- (void)terminate
{
	int pid = _pid;
    callsystem_abort(&pid);
    _pid = pid;
}

- (int)terminationStatus
{
    int pid = _pid;
    int result = callsystem_running(&pid);
    _pid = pid;
    
    if (result < 256)
    {
        return result;
    }
    
    [NSException raise:NSInvalidArgumentException
                format:@"terminationStatus requested while task running"];
    return 0;
}

- (BOOL)isRunning
{
	int pid = _pid;
    int result = callsystem_running(&pid);
    _pid = pid;
    return result > 255;
}

- (void)waitUntilExit
{
    int pid = _pid;
    callsystem_finished(&pid);
    _pid = pid;
}

@end
