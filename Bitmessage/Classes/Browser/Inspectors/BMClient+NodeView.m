//
//  BMClient+UI.m
//  Bitmessage
//
//  Created by Steve Dekorte on 4/17/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "BMClient+NodeView.h"
#import "BMDraftController.h"

@implementation BMClient (NodeView)

- (NSArray *)uiActions
{
    NSArray *uiActions = [NSMutableArray arrayWithObjects:@"compose", /*@"export", @"import", */ nil];
    return  [uiActions arrayByAddingObjectsFromArray:super.uiActions];
}

- (void)compose
{
    BMDraftController *draft = [BMDraftController openNewDraft];
    [draft setDefaultFrom];
    [draft setCursorOnTo];
    [draft open];
}

- (void)composeBroadcast
{
    BMDraftController *draft = [BMDraftController openNewBroadcast];
    [draft setDefaultFrom];
    [draft setCursorOnBody];
    [draft open];
}

- (void)composeWithAddress:(NSString *)address
{
    BMDraftController *draft = [BMDraftController openNewDraft];
    [draft setDefaultFrom];
    [draft.to setStringValue:address];
    [draft setCursorOnTo];
    [draft open];
}

- (NSString *)verifyActionMessage:(NSString *)actionString
{
    if ([actionString isEqualToString:@"import"])
    {
        return @"CAUTION: This operation will delete your current Bitmessage mailbox and any identities you have in it. This will destroy the private keys for those identities making any mail sent to them permanently unreadable.";
    }
    
    return nil;
}

// import/export

/*
- (void)export
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setMessage:@"Choose a folder to place your exported mailbox file in"];
    
    NSWindow *window = [[NSApplication sharedApplication] mainWindow];
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton)
         {
             NSArray* urls = [panel URLs];
             NSURL *url = [urls firstObject];
             NSLog(@"url '%@'", url);
             [BMClient.sharedBMClient archiveToUrl:url];
         }
     }];
}

- (void)import
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setMessage:@"Choose a .bmbox file to import"];
    
    NSWindow *window = [[NSApplication sharedApplication] mainWindow];
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton)
         {
             NSArray *urls = [panel URLs];
             NSURL *url    = [urls firstObject];
             NSLog(@"url '%@'", url);
             [BMClient.sharedBMClient unarchiveFromUrl:url];
         }
         
     }];
}
 */

@end
