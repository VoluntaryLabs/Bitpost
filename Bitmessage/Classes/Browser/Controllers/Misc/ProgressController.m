//
//  ProgressController.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "ProgressController.h"

@implementation ProgressController

- (id)init
{
    self = [super init];
    [self listen];
    return self;
}

- (void)listen
{
    // eventually switch to holding a list of object/action/count we are waiting on?
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(progressPush:)
                                                 name:@"ProgressPush"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(progressPop:)
                                                 name:@"ProgressPop"
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)progressPush:(NSNotification *)note
{
    self.progressCount ++;
    [self update];
}

- (void)progressPop:(NSNotification *)note
{
    if (self.progressCount > 0)
    {
        self.progressCount --;
        [self update];
    }
}

- (void)setProgress:(NSProgressIndicator *)progress
{
    _progress = progress;
    [self.progress setDisplayedWhenStopped:NO];
    [self.progress setUsesThreadedAnimation:YES];
}

- (void)update
{
    if (self.progressCount)
    {
        self.useCount ++; // not pretty but simpler than managing thread
        
        [self performSelectorInBackground:@selector(startIfNeeded:)
                               withObject:[NSNumber numberWithInteger:self.useCount]];
    }
    else
    {
        [self.progress stopAnimation:self];
    }
}

- (void)startIfNeeded:(NSNumber *)startCount
{
    sleep(1);
    
    if (self.progressCount && startCount.integerValue == self.useCount)
    {
        [self.progress startAnimation:self];
    }
}

@end
