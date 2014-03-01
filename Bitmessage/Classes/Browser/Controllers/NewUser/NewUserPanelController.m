//
//  NewUserPanelController.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/27/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NewUserPanelController.h"
#import "BMClient.h"
#import "BMNewUserView.h"

@implementation NewUserPanelController

NSMutableArray *sharedInstances = nil;

+ (NSMutableArray *)sharedInstances
{
    if (!sharedInstances)
    {
        sharedInstances = [NSMutableArray array];
    }
    
    return sharedInstances;
}

+ (NewUserPanelController *)openNewUserPanel
{
    NewUserPanelController *conn = [[[self class] alloc] initWithNibName:@"NewUser" bundle:nil];
    [[[self class] sharedInstances] addObject:conn];
    [conn view]; // to force lazy load
    return conn;
}

- (NSWindow *)window
{
    return self.view.window;
}

- (void)loadView
{
    [super loadView];
    
    [[self window] setDelegate:self];

    BMClient *client = [BMClient sharedBMClient];
    BMIdentities *identities = [client identities];
    BMIdentity *newIdentity = [identities createFirstIdentity];
    
    self.userView = [[BMNewUserView alloc] initWithFrame:self.view.bounds];
    [self.userView setNode:(id <NavNode>)newIdentity];
    [self.view addSubview:self.userView];
    
    
    NSWindow *window = self.window;
    [NSApp runModalForWindow: window];
    
    [NSApp endSheet: window];
    
    [window orderOut: self];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [NSApp endSheet: self.window];
    [self.window orderOut: self];
    // close app?
}


@end
