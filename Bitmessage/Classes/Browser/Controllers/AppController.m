
#import "AppController.h"
#import <BitmessageKit/BitmessageKit.h>
#import <NavKit/NavKit.h>
#import "DraftController.h"
#import "InfoPanelController.h"
#import "BMNewUserView.h"

@implementation AppController

- (void)awakeFromNib
{
}

- (DraftController *)newDraft
{
    DraftController *draft = [DraftController openNewDraft];
    return draft;
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
    self.dockTile = [[NSApplication sharedApplication] dockTile];

    self.navWindow = [NavWindow newWindow];
    [_navWindow center];
    [_navWindow orderFront:nil];
    
    [_navWindow.navView setRootNode:(id <NavNode>)[BMClient sharedBMClient]];
    [_navWindow setTitle:@"launching server..."];
    [_navWindow display];
    
    self.progressController = [[ProgressController alloc] init];
    [self.progressController setProgress:_navWindow.progressIndicator];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProgressPush" object:self];
    

    NavColumn *firstNavColumn = [[_navWindow.navView navColumns] firstObject];
    [firstNavColumn selectRowIndex:0];
    
    [_navWindow setTitle:@""];
    
    [self checkForNewUser];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unreadCountChanged:)
                                                 name:@"BMReceivedMessagesUnreadCountChanged"
                                               object:BMClient.sharedBMClient.messages.received];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProgressPop" object:self];    
}

- (void)checkForNewUser
{
    if ([[BMClient sharedBMClient] hasNoIdentites] ||
        [[[[BMClient sharedBMClient] identities] firstIdentity] hasUnsetLabel])
    {
        [self openNewUserView];
    }
}

- (void)openNewUserView
{
    BMNewUserView *nuv = [[BMNewUserView alloc] initWithFrame:_navWindow.navView.frame];
    nuv.replacementView = _navWindow.navView;
    [nuv open];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[BMClient sharedBMClient] stopServer];
}

- (NSInteger)unreadMessageCount
{
    return [[[[BMClient sharedBMClient] messages] received] unreadCount];
}

- (void)unreadCountChanged:(NSNotification *)note
{
    // replace with notification -> sound mapping with theme lookup
    //NSLog(@"unreadCountChanged");
    [self displayUnreadMessageCountBadge];
}

- (void)displayUnreadMessageCountBadge
{
    NSInteger unreadMessageCount = [self unreadMessageCount];
    
    if (unreadMessageCount > 0)
    {
        [self.dockTile setBadgeLabel:[NSString stringWithFormat: @"%ld",
                                      (long)unreadMessageCount]];
    }
    else
    {
        [self.dockTile setBadgeLabel: nil];
    }
}

- (IBAction)openInfoPanel:(id)sender
{
    [[InfoPanelController sharedInfoPanelController] open];
}

- (IBAction)compose:(id)sender // hack - consolidate into DraftController
{
    AppController *appController = (AppController *)[[NSApplication sharedApplication] delegate];
    DraftController *draft = [appController newDraft];
    [draft setDefaultFrom];
    [draft setCursorOnTo];
    [draft open];
}

// import/export

- (IBAction)exportMailbox:(id)sender
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
             [[BMClient sharedBMClient] archiveToUrl:url];
         }
     }];
}

- (IBAction)importMailbox:(id)sender // import by double clicking on file instead?
{
    //[self performSelector:@selector(confirmImport) withObject:nil afterDelay:0.01];
}

- (void)confirmImport
{
    NSAlert *alert = [[NSAlert alloc] init];
    self.alertPanel = alert;
    [alert addButtonWithTitle:@"Import Mailbox"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Are you sure you want to replace your existing Bitmessage mailbox?"];
    [alert setInformativeText:@"CAUTION: This operation will delete your current Bitmessage mailbox and any identities you have in it. This will destroy the private keys for those identities making any mail sent to them permanently unreadable."];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    NSWindow *window = [[NSApplication sharedApplication] mainWindow];
    
    [alert beginSheetModalForWindow:window completionHandler:^(NSInteger returnCode)
    {
        // 1000 = OK
        // 10001 = Cancel
        // why doesn't NSModalResponseContinue have this value?
        
        if (returnCode == 1000)
        {
            [self doImport];
        }
    }];
    
    /*
    if ([alert runModal] == NSAlertFirstButtonReturn)
    {
        [self doImport];
    }
    */
}

- (void)doImport
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
            NSArray* urls = [panel URLs];
            NSURL *url = [urls firstObject];
            NSLog(@"url '%@'", url);
            [[BMClient sharedBMClient] unarchiveFromUrl:url];
        }
        
    }];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    NSLog(@"open '%@'", filename);
    return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    NSLog(@"open filenames");
}

@end
