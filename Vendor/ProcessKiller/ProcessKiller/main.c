//
//  main.c
//  ProcessKiller
//
//  Created by Steve Dekorte on 2/17/14.
//
//

#include <stdio.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <unistd.h>
#include <errno.h>

int main(int argc, const char * argv[])
{
    pid_t parentPid = atoi(argv[1]);
    pid_t childPid  = atoi(argv[2]);
    
    // watch parent, if it dies, kill the child and exit
    
    while (1)
    {
        sleep(1);
        
    }
    
    return 0;
}

